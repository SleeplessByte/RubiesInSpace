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
		@ships = []
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
	def scan_paths( scanner = nil )
		@connections.map { | p | p.scan( scanner ) }
	end
	
	#
	#
	def join( ship )
		@ships.push ship
	end
	
	#
	#
	def leave( ship )
		@ships.delete ship
	end
	
	#
	#
	def ships
		@ships.select { |s| s.alive? }
	end
	
	##
	#
	#
	def to_s
		"#{ self.class.name[ 0 ] }#{ self.object_id.to_s[ -4..-1 ] }"
	end
		
	##
	#
	#
	def collect( c )
		return 0
	end
	
	
end