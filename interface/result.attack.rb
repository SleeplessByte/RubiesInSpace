class AttackResult
	
	attr_reader :source, :destination, :inflicted, :received
	
	def initialize( source, destination, inflicted, received )
		@source = source
		@destination = destination
		@inflicted = inflicted
		@received = received
	end
	
end