require 'benchmark'

class Player
	
	BASESCAN = 10
	BASETRAVEL = 10
	BASEFUEL = 1
	BASECOLLECT = 20
	
	PRETRAVEL = 10
	POSTTRAVEL = 10
	
	PRECOLLECT = 10
	
	attr_reader :crews, :ships, :time, :last_time, :secret, :progress
	
	#
	#
	def initialize( crew )
		
		@constructor = crew
		test @constructor.new 
		
		# Create the ship
		@ships = []
		@crews = []
		
		build()
		@secret = @crews[ 0 ].identifier

		@time = 0.0
		@last_time = 0.0
	end
	
	#
	#
	def build( data = {} )
		ship = Ship.new( data )
		crew = @constructor.new
		
		# Board and own
		ship.donate self, crew
		@ships.push ship
		@crews.push crew
		return ship
	end
	
	##
	#
	#
	def identifier
		self.object_id
	end
	

	def dead?
		@ships.all? { | s | s.dead? }
	end
	
	##
	# Test if crew is not missing methods
	#
	def test( crew )
		[ 'board', 'step', 'event', 'identifier' ].each do | method |
			if not crew.respond_to?( method )
				raise "Crew should respond to #{method}"
			end
		end
	end
	
	##
	# Spawn the player on a node
	#
	def spawn( node, ship = @ships[ 0 ] )
		ship.travel( node )
		ship.join
		Space.timestamped 0, "Spawned #{ ship.identifier } on #{ ship.interface.position }"
	end
	
	##
	# Steps the crew
	#
	def step( t )
						
		actions = []
		@last_time = 0
		
		@ships.each do | ship |
			next if ship.dead?
			next if ship.busy?
			
			bm = Benchmark.measure do
				ship.crew.step t
			end
			actions.push( { 
				:action => ship.advance, 
				:ship => ship, 
				:player => self, 
				:time => bm.utime, 
				:state => :request
			} )
			@last_time += bm.utime
		end
		
		# make total - don't care about system time
		@time += @last_time
		
		return actions
	end
	
	##
	#
	#
	def process( t, ship, action, time, state )
		
		return :kill unless action.respond_to? :source
		if ship.interface != action.source
			Space.log "Is this a hacking attempt by #{ identifier }?"
			return :kill 
		end
			
		do_method = "#{state}_#{ action.class.name.downcase.sub( 'action', '' ) }"
		if respond_to? do_method
			print "\r                                                                            \r"
			print "exec: #{ ship } do #{ do_method } on #{ Space.stardate t }"
			return send( do_method, t, ship, action )
		end
		
		if ship.busy?
			print "\r                                                                            \r"
			print "busy: #{ ship } do #{ do_method } on #{ Space.stardate t }"
			return ship.progress ? :finish : :continue
		end
		
		print "\r                                                                            \r"
		print "kill: #{ ship } do #{ do_method } on #{ Space.stardate t }"
		return :kill
	end
	
	##
	#
	#
	def request_scan( t, ship, action )
		duration = 1 + [ BASESCAN - ship.stat( :efficiency ) , -1 ].max
		ship.duration = duration
		
		# Determine data
		location = ship.location
		source = ship.interface
		
		# TODO variance
		# TODO tech
		# Get result
		environment = location.scan()
		paths = location.scan_paths()		
		ships = location.ships
		friendlies = ships.select { |s| s.owner == ship.owner }.map { |s| s.scan() }
		enemies = ships.select { |s| s.owner != ship.owner }.map { |s| s.scan() }
		ship.result = ScanResult.new( t, source, environment, paths, friendlies, enemies )
		return :continue
	end
	
	##
	#
	#
	def request_travel( t, ship, action )
				
		location = ship.location
		path = location.paths.find { |p| p[ :to ].identifier == action.node }
		return :kill unless path
		
		# Determine time 
		# TODO variance
		# todo tech
		duration = 1 + PRETRAVEL + [ BASETRAVEL * ( path[ :distance ] - ship.stat( :speed ) ) , -1 ].max + POSTTRAVEL
		ship.duration = duration
		
		distance = path[ :distance ]
		source = ship.interface
		node = action.node
		ship.result = TravelResult.new( t, source, node, distance, duration, 0 )
		
		return :pre
	end
	
	def pre_travel( t, ship, action )
		if ship.progress
			return :kill 
		end
		
		# TODO variance?
		# TODO tech?
		if ship.progress_duration > PRETRAVEL 
			
			location = ship.location
			path = location.paths.find { |p| p[ :to ].identifier == action.node }
			return :kill unless path
			
			ship.leave
			ship.travel( path[ :to ] )
			return :continue
		end
		
		return :pre
	end
	
	def continue_travel( t, ship, action )
		if ship.progress
			return :post
		end
		
		# TODO variance
		# TODO tech
		# Get data
		depletion = BASEFUEL * ( 1 - ship.stat( :efficiency ) / 100.to_f )
		depletion = ship.consume( depletion, :deuterium )
				
		# Get result
		ship.result.depletion = ship.result.depletion + depletion
		if ship.progress_duration - PRETRAVEL >  ship.result.duration - POSTTRAVEL
			ship.join
			return :post
		end
		
		return :continue
	end
	
	##
	#
	#
	def post_travel( t, ship, action )
		return ship.progress ? :finish : :post
	end
	
	def finish_travel( t, ship, action )
		ship.result.finalize
		return :kill
	end
	
	##
	#
	#
	def request_collect( t, ship, action )
		
		# Determine time 
		duration = action.duration
		ship.duration = duration
	
		# TODO variance
		# TODO tech
		collected = 0
		location = ship.location
		source = ship.interface 
		
		# Get result
		ship.result = CollectResult.new( t, source, 0 )
		return :pre
	end
	
	def pre_collect( t, ship, action )
		return :kill if ship.progress
		
		# TODO variance?
		# TODO tech?
		return ship.progress_duration > PRECOLLECT ? :continue : :pre
	end
	
	##
	#
	#
	def continue_collect( t, ship, action )
		
		collection = BASECOLLECT * ( 1 - ship.stat( :efficiency ) / 100.to_f )
		collection = ship.location.collect( collection.floor )
		ship.result.collected = ship.result.collected + ship.collect( collection )
		return ship.progress ? :finish : :continue
	end
	
	def finish_collect( t, ship, action )
		ship.result.finalize
		return :kill
	end
	
	##
	#
	#
	def to_s
		"Player #{ identifier }"
	end
	
end