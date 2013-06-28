require_relative 'iship.icomponent'

#
#
class ShipInterface
	
	#
	#
	class Engine < ComponentInterface
		
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