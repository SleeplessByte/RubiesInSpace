require_relative 'iship.icomponent'

#
#
class ShipInterface
	
	#
	#
	class WeaponsRack < ComponentInterface
				
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