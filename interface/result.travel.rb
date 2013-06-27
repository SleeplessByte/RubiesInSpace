class TravelResult
	
	attr_reader :source, :node, :depletion, :distance, :duration, :timestamp, :log
	
	def initialize( timestamp, source, node, distance, duration, depletion )
		@timestamp = timestamp
		@source = source
		@node = node
		@depletion = depletion
		@distance = distance
		@duration = duration
	end
	
	def depletion=(value)
		@depletion = value
	end
	
	def finalize
		@log = SpaceLog.generate( :result, :travel, self )
		self.freeze
	end
	
	def to_s
		@log
	end
end