require_relative 'ship.component'
require_relative 'ship.weapon'

#
#
class Ship
	
	#
	#
	class WeaponsRack < Component
		
		attr_reader :warmup, :slots, :weapons
		
		##
		#
		#
		def initialize( ship, warmup = 10, slots = 1 )
			super ship
			
			@warmup = warmup
			@slots = 2
			
			@weapons = []
			install Weapon.new( ship, self )
			activate @weapons.first
		end
		
		##
		#
		#
		def install( weapon )
			@weapons.push weapon unless @weapons.include? weapon
		end
		
		##
		#
		#
		def activate( weapon )
			return false unless slots_free >= weapon.size
			weapon.activate
			return true
		end
		
		##
		#
		#
		def deactivate( weapon )
			weapon.deactivate
		end
		
		##
		#
		#
		def slots_free
			@slots - active_weapons.inject( 0, :+ )
		end
		
		##
		#
		#
		def active_weapons
			@weapons.select { |w| w.active? }
		end
		
		##
		#
		#
		def prepare( t, action, target )
			
			duration = @warmup
			result = Interface::AttackReport.new( 
				t, ship.interface, target.interface, 0, 0
			)
			target_event = Space::Event::AttackIncoming.new(
				t, ship.identifier, 0
			)
			target.event target_event
			
			return {
				:duration => duration,
				:result => result				
			}
		end
		
		#
		#
		#
		def fire( t, action, target )
		
			results = active_weapons.map { |w| w.fire( t, action, target ) }
			depletion = results.map { |r| r[ :depletion ] }.inject( 0, :+ )
			damage = results.map { |r| r[ :damage ] }.inject( 0, :+ )
			
			# Define the target attack event
			target_event = Space::Event::AttackIncoming.new(
				t, ship.identifier, 0
			)
			target.event target_event
			
			# Define local attack event
			event = Space::Event::AttackOutgoing.new(
				t, target.identifier, damage, depletion
			)
			return {
				:damage => damage,
				:event => event,
				:depletion => depletion				
			}
		end
	end
end