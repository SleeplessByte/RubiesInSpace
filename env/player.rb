require 'benchmark'

class Player
		
	attr_reader :crews, :ships, :time, :last_time, :secret, :progress
	
	#
	#
	def initialize( crew )
		
		@constructor = crew
		test ( template = @constructor.new )
		
		# Create the ship
		@ships = []
		@crews = []
		
		@secret = template.identifier

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
	
	##
	#
	#
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
	def spawn( node, data = {} )
		ship = build( data )
		ship.command_center.travel( node )
		ship.command_center.join
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
				:action => ship.command_center.advance, 
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
		return :kill if ship.command_center.killed?
		return :kill unless action.respond_to? :source
		if ship.interface != action.source
			Space.log "Is this a hacking attempt by #{ identifier }?"
			ship.command_center.kill
			return :kill 
		end
			
		do_method = "#{state}_#{ action.class.name.downcase.sub( 'command', '' ).split( ':' ).last }"
		if  ship.command_center.respond_to? do_method
			print "\r                                                                            \r"
			print "exec: #{ ship } do #{ do_method } on #{ Space.stardate t }"
			result = ship.command_center.send( do_method, t, action )
			return result
		end
		
		if ship.busy?
			print "\r                                                                            \r"
			print "busy: #{ ship } do #{ do_method } on #{ Space.stardate t }"
			return ship.command_center.progress ? :finish : :continue
		end
		
		print "\r                                                                            \r"
		print "kill: #{ ship } do #{ do_method } on #{ Space.stardate t }"
		return :kill
	end
	
	##
	#
	#
	def to_s
		"Player #{ identifier }"
	end
	
end