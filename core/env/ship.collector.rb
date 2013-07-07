require_relative 'ship.component'

#
#
class Ship

	#
	#
	class Collector < Component
		
		attr_reader :warmup, :power, :efficiency
		
		##
		#
		#
		def initialize( ship, warmup = 20, power = 20, efficiency = 5 )
			super ship

			@warmup = warmup
			@power = power
			@efficiency = efficiency
			
		end
		
		##
		#
		#
		def request( t, action )
			duration = action.duration
			result = Interface::CollectReport.new( t, ship.interface , 0 )
			return { 
				:duration => duration,
				:result => result
			}
		end
		
		##
		#
		#
		def execute( t, action )
			
			collection = @power * ( 1 - @efficiency / 100.to_f )
			collection = ship.location.collect( collection.floor )
			collection = ship.collect( collection )
			
			return { :collected => collection }
		end
		
	end
end