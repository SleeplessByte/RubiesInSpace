require_relative 'iship.icomponent'

#
#
class Ship

	class Interface
		
		#
		#
		class WeaponsRack < ComponentShip
					
			def warmup
				@component.warmup
			end
			
			def rate
				@component.rate
			end
			
			def power
				@component.power
			end
			
		end
		
	end
	
end