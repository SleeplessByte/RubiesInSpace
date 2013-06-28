require_relative 'iship.icomponent'

#
#
class ShipInterface
	
	#
	#
	class Collector < ComponentInterface
		
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