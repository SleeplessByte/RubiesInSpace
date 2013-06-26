require_relative 'spacenode'

#
#
class Asteroid < SpaceNode

	attr_reader :size
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
	end
	
end