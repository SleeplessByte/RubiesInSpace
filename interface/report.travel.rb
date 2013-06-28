require_relative 'report'

class ShipInterface

	class TravelReport < CommandReport
	
		attr_reader :node, :distance, :duration, :timestamp
		attr_accessor :depletion
		
		def initialize( timestamp, source, node, distance, duration, depletion )
			super timestamp, source
			@node = node
			@depletion = depletion
			@distance = distance
			@duration = duration
		end

	end
end