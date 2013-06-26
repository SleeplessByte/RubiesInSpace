require_relative '../interface/iship'

#
#
class Ship

	attr_reader :interface, :data
	attr_accessor :result
	
	##
	#
	#
	def initialize( data = {} )
	
		@resources = {
			:deuterium => {
				:value => 50,
				:capacity => 5000
			}
		}
		
		@stats = {
			:speed => 1,
			:efficiency => 5
		}
		
		@result = nil
		@position = nil
		
		@actions = []
		@events = []
		
		@interface = IShip.new self
		@data = data
	end
	
	#
	#
	def donate( owner )
		@owner = owner
	end
	
	#
	#
	def amount_of( resource = :deuterium )
		@resources[ resource ][ :value ]
	end
	
	#
	#
	def capacity( resource = :deuterium )
		@resources[ resource ][ :capacity ]
	end
	
	#
	#
	def collect( amount, resource = :deuterium )
		before_amount = amount_of( resource )
		@resources[ resource ][ :value ] = [ amount_of( resource ) + amount, capacity( resource ) ].min
		return  amount_of( resource ) - before_amount
	end
	
	#
	#
	def consume( amount, resource = :deuterium )
		before_amount = amount_of( resource )
		@resources[ resource ][ :value ] = [ amount_of( resource ) - amount, 0 ].max
		return before_amount - amount_of( resource )
	end
	
	#
	#
	def position
		@location.identifier
	end
	
	#
	#
	def travel( node )
		@location = node
	end
	
	#
	#
	def damage( value )
		consume value
	end
	
	#
	#
	def stat( resource )
		@stats[ resource ]
	end
	
	#
	#
	def current
		@actions[ 0 ]
	end
	
	##
	#
	#
	def queue( action )
		@actions.push action
	end
	
	##
	#
	#
	def clear_queue()
		@actions = []
	end

end