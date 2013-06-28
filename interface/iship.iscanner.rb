require_relative 'iship.icomponent'

#
#
class ShipInterface
	
	#
	#
	class Scanner < ComponentInterface
				
		def efficiency
			@component.efficiency
		end
		
	end
	
end