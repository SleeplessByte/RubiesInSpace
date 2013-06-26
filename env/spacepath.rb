require_relative 'spacenode'
#
#
class SpacePath
	
	attr_reader :alpha, :beta, :distance
	
	##
	#
	#
	def initialize( alpha, beta, distance )
		
		unless alpha.is_a?( SpaceNode ) and beta.is_a?( SpaceNode )
			raise TypeError.new "That is not a SpaceNode"
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
		return false unless other.is_a? SpacePath
		return false if other.distance != @distance
		if ( other.alpha == @alpha and other.beta == @beta ) 
			return ( other.alpha == @beta and other.beta == @alpha )
		end
		
	end
	
	##
	#
	#
	def scan( tech = {} )
		return {
			:alpha => @alpha.identifier,
			:beta => @beta.identifier,
			:distance => @distance
		}
	end
	
	
end