require_relative 'asteroid'
require_relative 'star'
require_relative 'planet'
require_relative 'spacenode'
require_relative 'spacepath'
require_relative 'lab'
require_relative 'factory'
require 'graph'

##
# This is space. This is where the rubies are!
class Space
	
	attr_reader :birthdate, :nodes, :configuration
	
	##
	#
	#
	VERSION  = '1.0.0'
	
	##
	#
	#
	ENTROPY = 4
	
	##
	#
	#
	UNIVERSE = {
		
		##
		# The number of nodes
		:size => 32,
		
		##
		# The ratios of the types 
		:ratios => {
			:stars => 9,
			:planets => 4
		},
		
		##
		# The distances between nodes
		:distances => {
			:min => 10,
			:max => 50,
			:connecting => 100
		},
		
		##
		# The connectivity of the graph
		:connectivity => {
			:closed => true,
			
			##
			# Nodes + Faces - Connections = 1.
			# :size / :faces = number of faces
			:faces => 3
		},
		
		##
		#
		:dice => {
			
			##
			# Chance of stars without planets 
			:lonely_star => 5,
			
			##
			# Chance of asteroid not being a traveller
			:sparse_asteroid => 4
		},
		
		##
		#
		:variance => 15
			
	}
	
	##
	# Creates space from a set of options
	#
	def initialize( options )
		
		##
		# Lets test the options and exist early
		#
		unless options[ :secrets ].is_a? Array
			raise ArgumentError.new "I really need some secrets"
		end
		
		##
		# The birthdate of the universe. We use this for a registration time of the game
		# but also to generate the universe. However, we wouldn't want the player to know
		# what the time is, so what we do is let the players give a secret ( like file name ).
		# A player can now still figure out the seeding process, but doing so is an achievement.
		#
		@birthdate = options[ :birthdate ] || Time.now()
		
		##
		# Here build the universe blueprint
		#
		@configuration = hash_defaults( options[ :universe ] || {} , UNIVERSE )
		
		##
		# Time to build that randomizer.
		#
		@seed = build_seed( options[ :secrets ].sort.join( '+' ) + @birthdate.to_i.to_s )
		
		##
		#
		#
		@@randomizer = Random.new @seed
		
	end
	
	##
	# 
	#
	def fill( nodes ) 
		@nodes = nodes
	end
	
	##
	# Fills the defaults hash with values if the keys are present
	#
	def hash_defaults( values, defaults )
		results = {}
		defaults.each_pair { |key, value|
			results[ key ] = if value.is_a? Hash
				hash_defaults( values[ key ] || {}, value )
			else
				values[ key ] || value
			end
		}
		return results
	end
	
	##
	# Gets a number of random bytes
	#
	def self.bytes( n )
		result = []
		( @@randomizer.bytes n ).each_char { |c| result.push c.ord }
		return result
	end
	
	##
	# Gets a random number for a range or max value
	#
	def self.rand( arg )
		return @@randomizer.rand arg
	end
	
	##
	#
	#
	def self.log( args )
		puts args
	end
		
	protected
	##
	# Builds the seed for this universe
	# 
	def build_seed( seed_string )
		result = ""
		seed_string.each_byte { | ord | result += ord.to_s }
		return result.to_i % ( 2 ** 32 ) 
	end	
end