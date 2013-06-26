require_relative 'spacepath'
# The space node
#
class SpaceNode
		
	##
	#
	#
	def initialize( seed )
		@seed = seed
		@connections = []
	end

	##
	#
	#
	def identifier
		self.object_id
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
	
	##
	#
	#
	def connections
		@connections.map { | c | c.alpha === self ? c.beta : c.alpha }
	end
	
	##
	#
	#
	def paths
		@connections.map { | c | { :to => c.alpha === self ? c.beta : c.alpha, :distance => c.distance } }
	end
	
	##
	#
	#
	def to_s
		"#{ self.class.name[ 0 ] }#{ self.object_id.to_s[ -4..-1 ] }"
	end
	
end