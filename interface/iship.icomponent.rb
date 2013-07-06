class Ship

	##
	#
	#
	class Interface

		# weapons
		# upgrades
		# tech
		# ...
		
		class ComponentShip

			def initialize( ship, component, interface )
				@ship = ship
				@interface = interface
				@component = component
				self.freeze
			end	
			
		end
		
	end
	
end