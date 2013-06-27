class TravelResult
	
	attr_reader :source, :node, :depletion, :distance, :duration, :timestamp, :log
	
	def initialize( timestamp, source, node, distance, duration, depletion )
		@timestamp = timestamp
		@source = source
		@node = node
		@depletion = depletion
		@distance = distance
		@duration = duration
		@log = SpaceLog.generate( :result, :travel, self )
	end
	
	def to_s
		@log
	end
end