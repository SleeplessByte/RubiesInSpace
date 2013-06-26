class TravelResult
	
	attr_reader :source, :node, :depletion
	
	def initialize( source, node, depletion )
		@source = source
		@node = node
		@depletion = depletion
	end
	
end