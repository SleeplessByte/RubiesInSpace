require_relative 'ship.component'

#
#
class Ship
	
	#
	#
	class WeaponsRack < Component
		
		def initialize( ship, warmup = 10, rate = 1, power =1 )
			super ship
			
			@warmup = warmup
			@rate = rate
			@power = power
		end
	end
end