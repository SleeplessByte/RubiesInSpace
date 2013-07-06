require_relative 'space.node'

module Space

	#
	#
	class Asteroid < Space::Node

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
		def scan( scanner = nil )
			return {
				:type => self.class,
				:size => @size,
				:deuterium => @deuterium,
			}
		end
		
		# TODO k_m
		#
		def collect( c )
			
			collection = [ c, @deuterium ].min
			@deuterium -= collection
			return collection
		end
		
	end
	
end