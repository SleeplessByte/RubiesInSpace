##
class ShipInterface

	# weapons
	# upgrades
	# tech
	# ...
	
	class ComponentInterface

		def initialize( ship, interface )
			@ship = ship
			@interface = interface
			self.freeze
		end	
		
		def ship
			@ship
		end
		
		def interface
			@interface
		end
		
	end
	
end