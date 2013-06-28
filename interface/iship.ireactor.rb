require_relative 'iship.icomponent'

#
#
class ShipInterface
	
	#
	#
	class Reactor < ComponentInterface
				
		def efficiency
			@component.efficiency
		end
		
	end
	
end