class CollectResult
	
	attr_reader :source, :collected
	
	def initialize( source, collected )
		@source = source
		@collected = collected
	end
	
end