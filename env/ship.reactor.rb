require_relative 'ship.component'

#
#
class Ship
	
	BASEFUEL = 1
	
	#
	#
	class Reactor < Component
		
		attr_reader :efficiency
		
		def initialize( ship, efficiency = 5 )
			super ship

			##
			# The reactor efficiency
			# 0...100
			@efficiency = efficiency
		end
		
		#
		#
		#
		def fly( t, action )
						
			# TODO something with engine power. More power > more fuel
			#
			depletion = BASEFUEL * ( 1 - @efficiency / 100.to_f )
			depletion = ship.consume( depletion, :deuterium )
			return { :depletion => depletion }
			
		end
		
	end
end