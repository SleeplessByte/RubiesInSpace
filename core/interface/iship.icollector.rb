require_relative 'iship.icomponent'

#
#
class Ship

	class Interface
	
		#
		#
		class Collector < ComponentShip
			
			def warmup
				@component.warmup
			end
			
			def power
				@component.power
			end
			
			def efficiency
				@component.efficiency
			end
			
		end
		
	end
	
end