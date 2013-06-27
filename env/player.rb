require 'benchmark'

class Player
	
	BASESCAN = 10
	BASETRAVEL = 10
	BASEFUEL = 1
	
	attr_reader :crews, :ships, :time, :last_time, :secret, :progress
	
	#
	#
	def initialize( crew )
		
		# Create the crew
		@crews = [ crew.new ]
		test @crews[ 0 ]
		
		# Create the ship
		@ships = [ Ship.new() ]
		
		# Board and own
		@ships[ 0 ].donate self, @crews[ 0 ]
		@secret = @crews[ 0 ].identifier

		@time = 0.0
		@last_time = 0.0
	end
	
	##
	#
	#
	def identifier
		self.object_id
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
		Space.timestamped 0, "Spawned #{ identifier } on #{ ship.interface.position }"
	end
	
	##
	# Steps the crew
	# @todo stop if all ships dead
	def step( t )
						
		bm = Benchmark.measure do
			@ships.each do | ship |
				next if ship.dead?
				next if ship.busy?
				ship.crew.step t
			end
		end
		
		# make total - don't care about system time
		@last_time = bm.utime
		@time += bm.utime
	end
	
	##
	# Processes the actions
	#
	def process( t )
		
		@ships.each do | ship |
			
			if ship.busy?
				ship.progress
				next
			end
			
			action = ship.advance
			if action != nil
				next unless action.respond_to? :source
				if ship.interface != action.source
					Space.log "Is this a hacking attempt by #{ identifier }?"
					next
				end
				
				do_method = "do_#{ action.class.name.downcase.sub( 'action', '' ) }"
				send( do_method, t, ship, action ) if respond_to? do_method
			end
			
		end
	end
	
	##
	#
	#
	def do_scan( t, ship, action )
				
		# Determine time
		duration = 1 + [ BASESCAN - ship.stat( :efficiency ) , -1 ].max
		ship.duration = duration
		
		# Determine data
		location = ship.location
		source = ship.interface
		
		# Get result
		environment = location.scan()
		paths = location.scan_paths()		
		ships = location.ships
		friendlies = ships.select { |s| s.owner == ship.owner }.map { |s| s.scan() }
		enemies = ships.select { |s| s.owner != ship.owner }.map { |s| s.scan() }
		ship.result = ScanResult.new( t, source, environment, paths, friendlies, enemies )
	end
	
	def do_travel( t, ship, action )
				
		location = ship.location
		path = location.paths.find { |p| p[ :to ].identifier == action.node }
		return unless path
		
		# Determine time @todo tech
		duration = 1 + [ BASETRAVEL * ( path[ :distance ] - ship.stat( :speed ) ) , -1 ].max
		ship.duration = duration
		
		# Get data @todo tech
		depletion = BASEFUEL * duration * ( 1 - ship.stat( :efficiency ) / 100.to_f )
		ship.travel( path[ :to ] )
		depletion = ship.consume( depletion, :deuterium )
		distance =  path[ :distance ]
		source = ship.interface
		node = action.node
		
		# Get result
		ship.result = TravelResult.new( t, source, node, distance , duration, depletion )
	end
	
end