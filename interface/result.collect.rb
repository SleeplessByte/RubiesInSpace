class CollectResult
	
	attr_reader :timestamp, :source, :collected, :log
	
	def initialize( t, source, collected )
		@source = source
		@collected = collected
		@log = SpaceLog.generate( :result, :collect, self )
	end
	
	def to_s
		@log
	end
	
end