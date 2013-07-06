require_relative 'iship.icomponent'

#
#
class Ship

	class Interface
	
		#
		#
		class Engine < ComponentShip
			
			def warmup
				@component.warmup
			end
			
			def power
				@component.power
			end
			
			def cooldown
				@component.cooldown
			end
			
		end
		
	end
	
end