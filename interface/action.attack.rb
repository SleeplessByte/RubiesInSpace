class AttackAction
	
	attr_reader :source, :destination
	
	def initialize( source, destination )
		@source = source
		@destination = destination
	end
	
end