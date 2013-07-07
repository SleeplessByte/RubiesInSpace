require_relative 'iship.icomponent'

#
#
class Ship

	class Interface
	
		#
		#
		class Scanner < ComponentShip
					
			def efficiency
				@component.efficiency
			end
			
		end
	
	end
	
end