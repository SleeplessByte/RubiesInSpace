class CollectResult
	
	attr_reader :timestamp, :source, :collected, :log
	
	def initialize( t, source, collected )
		@source = source
		@collected = collected
	end
	
	def collected=(value)
		@collected = value
	end
	
	def finalize
		@log = SpaceLog.generate( :result, :collect, self )
		self.freeze
	end
	
	def to_s
		@log
	end
	
end