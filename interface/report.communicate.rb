require_relative 'report'

class ShipInterface

	class CommunicateReport < CommandReport
	
		attr_reader :depletion
		
		def initialize( timestamp, source, depletion )
			super timestamp, source
			@depletion = depletion
		end
		
	end
end