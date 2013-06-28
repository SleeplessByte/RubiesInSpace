require_relative 'report'

class ShipInterface

	class AttackReport < CommandReport

		attr_reader :destination, :inflicted, :received
		
		def initialize( timestamp, source, destination, inflicted, received )
			super timestamp, source
			@destination = destination
			@inflicted = inflicted
			@received = received
		end
		
	end
end