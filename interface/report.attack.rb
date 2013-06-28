require_relative 'report'

class ShipInterface

	class AttackReport < CommandReport

		attr_reader :destination
		attr_accessor :damage, :depletion
		
		def initialize( timestamp, source, destination, damage, depletion )
			super timestamp, source
			@destination = destination
			@damage = damage
			@depletion = depletion
		end
		
	end
end