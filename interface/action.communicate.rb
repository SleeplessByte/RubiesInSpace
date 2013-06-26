class CommunicateAction
	
	attr_reader :source, :data
	
	def initialize( source, data )
		@source = source
		@data = data
	end
	
end