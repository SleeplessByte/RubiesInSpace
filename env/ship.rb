require_relative '../interface/iship'

##
# The ship class holds the crew and is the main component on which
# all the actions are invoked. It can't be directly accessed by the
# crew. They can only use an interface for the ship.
#
class Ship

	attr_reader :interface, :data, :crew, :owner
	attr_accessor :result
	
	##
	# Creates the new ship. A crew can pass on any amount of data to
	# the new ship, as long as this is an hash.
	# 
	def initialize( data = {} )
			
		unless data.is_a? Hash	
			raise TypeError.new "Data has to be a hash!"
		end
		
		##
		# The resources of the ship
		#
		@resources = {
		
			:deuterium => {
				:value => 500,
				:capacity => 5000
			}
			
		}
		
		##
		# The components of the ship
		#
		@components = {}
		@components[ :command_center ] = build_command_center()
		@components[ :engine ] = build_engine()	
		@components[ :reactor ] = build_reactor()
		@components[ :scanner ] = build_scanner()
		@components[ :collector ] = build_collector()
		@components[ :weapons_rack ] = build_weapons_rack()
		
		##
		# The installed upgrades of the ship
		#
		@upgrades = {}
		@data = data
	end
	
	##
	#
	#
	def rand( n = nil )
		return @randomizer.rand if n.nil?
		return @randomizer.rand n
	end
	
	##
	#
	#
	def bytes( n )
		@randomizer.bytes n
	end
	
	
	##
	# The ship identifier
	#
	def identifier
		self.object_id
	end
	
	##
	# The ship dead status
	#
	def dead?()
		not alive?()
	end
	
	##
	# The ship alive status
	#
	def alive?()
		amount_of( :deuterium ) > 0
	end
	
	##
	# The ship busy status
	#
	def busy?()
		command_center.busy?
	end
	
	##
	# The ship location
	#
	def location()
		command_center.location
	end
	
	##
	# Donates the ship to the owner and crew
	#
	def donate( owner, crew )
		@owner = owner
		@crew = crew

		@randomizer = Random.new Space::Universe.rand( 2 ** 32 )
		@interface = Interface.new self
		
		@crew.board @interface
	end
	
	## 
	# Checks the amount of resource
	#
	def amount_of( resource = :deuterium )
		@resources[ resource ][ :value ]
	end
	
	##
	# Checks the capacity of resource
	#
	def capacity( resource = :deuterium )
		@resources[ resource ][ :capacity ]
	end
	
	##
	# Collects the amount of resource
	#
	def collect( amount, resource = :deuterium )
		before_amount = amount_of( resource )
		@resources[ resource ][ :value ] = [ amount_of( resource ) + amount, capacity( resource ) ].min
		return amount_of( resource ) - before_amount
	end
	
	##
	# Consumes the amount of resource
	#
	def consume( amount, resource = :deuterium )
		before_amount = amount_of( resource )
		@resources[ resource ][ :value ] = [ amount_of( resource ) - amount, 0 ].max
		return before_amount - amount_of( resource )
	end
			
	##
	# Damages the ship
	#
	def damage( value )
		consume value, :deuterium
	end
	
	##
	# Gets the command center
	#
	def command_center
		@components[ :command_center ]
	end
	
	##
	# Gets the enige
	#
	def engine
		@components[ :engine ]
	end
	
	##
	# Gets the reactor
	#
	def reactor
		@components[ :reactor ]
	end
	
	##
	# Gets the scanner
	#
	def scanner
		@components[ :scanner ]
	end
	
	##
	# Gets the collector
	#
	def collector
		@components[ :collector ]
	end
	
	##
	# Gets the weapons rack
	#
	def weapons_rack
		@components[ :weapons_rack ]
	end
	
	##
	# Scans this ship
	#
	def scan( scanner = nil )
		return {
			:identifier => identifier,
			:owner => owner.identifier
			#:components => foreach component, scan it!
		}
	end
	
	##
	#
	#
	def event( event )

		#check if traveling TODO
		non_abortable = false
		result = @crew.event event
		
		if non_abortable or result
			return true
		end

		command_center.kill
		return false
	end
	
	##
	# Returns the string representation
	#
	def to_s
		@interface.to_s
	end
	
	protected
	def build_command_center
		CommandCenter.new self
	end
	def	build_engine
		Engine.new self
	end
	def build_reactor
		Reactor.new self
	end
	def build_scanner
		Scanner.new self
	end
	def build_collector
		Collector.new self
	end
	def build_weapons_rack
		WeaponsRack.new self
	end

end