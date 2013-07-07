require_relative 'space.node'

module Space

	class Path
		
		attr_reader :alpha, :beta, :distance
		
		##
		#
		#
		def initialize( alpha, beta, distance )
			
			unless alpha.is_a?( Space::Node ) and beta.is_a?( Space::Node )
				raise TypeError.new "That is not a Space::Node"
			end
			
			@alpha = alpha
			@beta = beta
			@distance = distance
		end
		
		##
		#
		#
		def to_s
			"#{ alpha } - #{ beta }"
		end
		
		##
		#
		#
		def ==( other )
			return false unless other.is_a? Space::Path
			return false if other.distance != @distance
			if ( other.alpha == @alpha and other.beta == @beta ) 
				return ( other.alpha == @beta and other.beta == @alpha )
			end
			
		end
		
		##
		#
		#
		def scan( scanner = nil )
			return {
				:alpha => @alpha.identifier,
				:beta => @beta.identifier,
				:distance => @distance
			}
		end
		
		
	end
	
end