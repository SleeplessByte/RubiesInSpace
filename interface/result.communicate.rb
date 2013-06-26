class CommunicateResult
	
	attr_reader :source, :depletion
	
	def initialize( source, depletion )
		@source = source
		@depletion = depletion
	end
	
end