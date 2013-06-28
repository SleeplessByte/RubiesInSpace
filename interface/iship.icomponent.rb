##
class ShipInterface

	# weapons
	# upgrades
	# tech
	# ...
	
	class ComponentInterface

		def initialize( ship, component, interface )
			@ship = ship
			@interface = interface
			@component = component
			self.freeze
		end	
		
	end
	
end