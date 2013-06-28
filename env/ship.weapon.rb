require_relative 'ship.component'

#
#
class Ship
	
	#
	#
	class Weapon < Component
	
		attr_reader :power, :rate, :size, :activated
	
		##
		#
		#
		def initialize( ship, rack, power = 50, rate = 1, size = 1 )
			super ship
			@rack = rack
			
			@power = power
			@rate = rate
			@size = size
			@activated = false
		end
		
		def active?
			@activated
		end
		
		def activate
			@activated = true
		end
		
		def deactivate
			@activated = false
		end
		
		##
		#
		#
		def fire( t, action, target )
			
			depletion = @rate * @size
			damage = 0
			@rate.times do 
				round = @power * ship.reactor.efficiency / 100.to_f 
				damage += round #todo variance
			end
			
			depletion = ship.consume depletion
			damage = target.damage damage
			
			return {
				:damage => damage,
				:depletion => depletion
			}
		end
		
	end
	
end