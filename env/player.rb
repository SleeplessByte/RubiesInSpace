require 'benchmark'

class Player
	
	attr_reader :crew, :ship, :time, :last_time, :secret
	
	#
	#
	def initialize( crew )
		
		# Create the crew
		@crew = crew.new 
		test @crew
		
		# Create the ship
		@ship = Ship.new()
		
		# Board and own
		@ship.donate self
		@crew.board @ship.interface
		@secret = @crew.identifier

		@time = 0.0
		@last_time = 0.0
	end
	
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
	def spawn( node )
		@ship.travel( node )
		Space.log "Spawned #{ identifier } on #{ @ship.interface.position }"
	end
	
	#
	#
	def step( t )
		bm = Benchmark.measure do
			crew.step t
		end
		
		# make total - don't care about system time
		@last_time = bm.utime
		@time += bm.utime
	end
	
end