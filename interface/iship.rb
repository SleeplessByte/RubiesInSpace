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
		@components[ :command_center ] = CommandCenter.new @ship, self
		self.freeze
	end
	
	##
	# Gets the ship identifier
	#
	def identifier
		@ship.object_id
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
	
	#
	#
	#
	def to_s
		"#{ name } (#{ identifier })"
	end
	
end