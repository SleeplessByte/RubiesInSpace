class BuildResult
	
	attr_reader :source, :item
	
	def initialize( source, item )
		@source = source
		@item = item
	end
	
end