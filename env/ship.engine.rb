require_relative 'ship.component'

#
#
class Ship

	BASETRAVEL = 10
	
	#
	#
	class Engine < Component
		
		attr_reader :power, :warmup, :cooldown
	
		def initialize( ship, power = 1, warmup = 20, cooldown = 20 )
			super ship
			
			##
			# The number of lightyears per day
			# 0...
			@power = power
			
			##
			# The number of days to prepare
			#
			@warmup = warmup
			
			##
			# The number of days to cooldown
			#
			@cooldown = cooldown
		end
		
		#
		#
		#
		def prepare( t, action, path )
			
			duration = ( BASETRAVEL * path[ :distance ] / @power.to_f ).round 
			distance = path[ :distance ]
			result = ShipInterface::TravelReport.new( 
				t, ship.interface, action.node, distance, duration, 0 
			)
		
			return {
				:duration => duration,
				:result => result
			}
		end
		
	end

end