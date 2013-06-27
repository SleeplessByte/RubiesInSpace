require_relative 'spacenode'

#
#
class Asteroid < SpaceNode

	attr_reader :size
	attr_reader :deuterium 
	
	#
	#
	def initialize( seed )
		
		super( seed )

		@size = seed[ 0 ]
		@deuterium = seed[ 1 ]
	end
	
	#
	#
	def scan( tech = {} )
		return {
			:type => self.class,
			:size => @size,
		}
	end
	
	#
	#
	def collect( c )
		collection = [ c, @deuterium ].min
		@deuterium -= collection
		return collection
	end
	
end