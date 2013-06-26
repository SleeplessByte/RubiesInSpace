require_relative 'spacenode'
#
#
class Star < SpaceNode
	
	attr_reader :size
	attr_reader :temperature
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@temperature = seed[ 1 ]
		@age = seed[ 2 ]
	end
	
end 