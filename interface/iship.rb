require_relative '../env/ship'

##
#
#
class ShipInterface
	
	attr_reader :name
	
	##
	# Create an ship interface
	#
	def initialize( ship )
		@ship = ship
		@name = ship.data[ :name ] || "Unnamed vessel"
		
		@components = {}
		@components[ :command_center ] = CommandCenter.new @ship, @ship.command_center, self
		@components[ :collector ] = Collector.new @ship, @ship.collector, self
		@components[ :engine ] = Engine.new @ship, @ship.engine, self
		@components[ :reactor ] = Reactor.new @ship, @ship.reactor, self
		@components[ :scanner ] = Scanner.new @ship, @ship.scanner, self
		@components[ :weapons_rack ] = WeaponsRack.new @ship, @ship.weapons_rack, self
		self.freeze
	end
		
	##
	# Gets the ship identifier
	#
	def identifier
		@ship.object_id
	end
	
	##
	# Seeded Random.rand
	#
	def rand( n = nil )
		@ship.rand n
	end
	
	##
	# Seeded Random.bytes
	#
	def bytes( n )
		@ship.bytes n
	end
	
	##
	# Gets the current position
	#
	def position
		@ship.location.identifier
	end
	
	##
	# Ship data passed at constructor
	#
	def data
		@ship.data
	end
	
	##
	# Get ship energy
	#
	def energy
		@ship.amount_of :deuterium
	end
	
	##
	# Get ship energy capacity
	#
	def energy_capacity
		@ship.capacity  :deuterium
	end
	
	##
	# Get energy ratio
	#
	def energy_ratio
		energy().to_f / energy_capacity
	end	

	##
	# Get action result
	#
	def report
		return command_center.report
	end
	
	def command_center
		return @components[ :command_center ]
	end
	
	def collector
		return @components[ :collector ]
	end
	
	def engine
		return @components[ :engine ]
	end
	
	def reactor
		return @components[ :reactor ]
	end
	
	def scanner
		return @components[ :scanner ]
	end
	
	def weapons_rack
		return @components[ :weapons_rack ]
	end
	
	#
	#
	#
	def to_s
		"#{ name } (#{ identifier })"
	end
	
end