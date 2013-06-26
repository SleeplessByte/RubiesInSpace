# The space node
#
class SpaceNode
		
	##
	#
	#
	def initialize( seed )
		@seed = seed
		@name = seed
		@connections = []
	end

	##
	# 
	#
	def connect( path )
		unless path.is_a? SpacePath
			raise TypeError.new "That is not a path"
		end
		
		@connections.push path
	end
	
	def connections
		@connections.map { | c | c.alpha === self ? c.beta : c.alpha }
	end
	
	def paths
		@connections.map { | c | { :to => c.alpha === self ? c.beta : c.alpha, :distance => c.distance } }
	end
	
	def to_s
		"#{ self.class.name }_#{ self.object_id }"
	end
	
end