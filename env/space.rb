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
	
	attr_reader :birthdate
	
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
		@universe = hash_defaults( options[ :universe ] || {} , UNIVERSE )
		
		##
		# Time to build that randomizer.
		#
		@seed = build_seed( options[ :secrets ].sort.join( '+' ) + @birthdate.to_i.to_s )
		@randomizer = Random.new @seed
		
		##
		# Finally build the entire space graph
		build @universe
		
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
	def bytes( n )
		result = []
		( @randomizer.bytes n ).each_char { |c| result.push c.ord }
		return result
	end
	
	##
	# Gets a random number for a range or max value
	#
	def rand( arg )
		return @randomizer.rand arg
	end
	
	def log( args )
		puts args
	end
		
	private
	##
	# Builds space
	#
	def build( universe )
		
		log "Creation of the Universe has started"
		
		# The Graph Stats
		num_nodes = universe[ :size ]
		num_faces = num_nodes / universe[ :connectivity ][ :faces ].to_f
		face_variance = num_faces / 100.to_f * universe[ :variance ]
		num_faces = ( num_faces + rand( face_variance ) - face_variance / 2.to_f ).round
		num_paths = num_nodes + num_faces - 1
		
		# The Graph Contents
		num_stars = num_nodes / universe[ :ratios ][ :stars ].to_f
		num_planets = num_nodes / universe[ :ratios ][ :planets ].to_f
		star_variance = num_stars / 100.to_f * universe[ :variance ]
		planet_variance = num_planets / 100.to_f * universe[ :variance ]
		num_stars = ( num_stars + rand( star_variance ) - star_variance  / 2.to_f ).round
		num_planets = ( num_planets + rand( planet_variance ) - planet_variance / 2.to_f ).round
		num_asteroids = num_nodes - num_stars - num_planets
		
		if num_stars <= 0
			raise ArgumentError "I can't create a universe that small."
		end
		
		nodes = []
		log "Developing #{num_stars} stars, mending #{num_planets} planets, throwing #{num_asteroids} asteroids, totalling in #{num_nodes} nodes with #{num_faces} faces and #{num_paths} paths"
		
		##
		# Lets make stars our cluster centers
		# 
		# For now we need star < planets
		#
		num_stars.times do
			nodes.push Star.new( bytes ENTROPY )
			num_stars -= 1
		end
		
		##
		# Some stars are lonely in their cluster. Let's find the cosy stars
		# because they will inherit all the planets, leaving the lonely star 
		# very lonely.
		#
		cosy_stars = nodes.select { |star| rand( universe[ :dice ][ :lonely_star ] ) > 0 }
		cosy_stars.push nodes.first() if cosy_stars.length == 0
		
		##
		# Cosy stars have at least one planet
		#
		cosy_stars.each do | star |
			
			# Create a planet and a path, so decrease these
			num_planets -= 1
			num_paths -= 1
			
			# Create the planet and the path
			planet = Planet.new( bytes ENTROPY )
			path = SpacePath.new planet, star, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
			
			# Connect the path
			star.connect path
			planet.connect path
			
			# Register the node
			nodes.push planet
		end
		
		##
		# Lets make those cosy stars really cosy
		#
		num_planets.times do 
			
			# Create a planet and a path, so decrease these
			num_planets -= 1
			num_paths -= 1
			
			# Create the planet and the path
			star = cosy_stars[ rand cosy_stars.length ]
			planet = Planet.new( bytes ENTROPY )
			path = SpacePath.new planet, star, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
			
			# Connect the path
			star.connect path
			planet.connect path
			
			# Register the node
			nodes.push planet
		end
		
		##
		# We created clusters of planets surrounding stars, so lets select those
		#
		clusters = nodes.select { | n | n.is_a? Star }.map { | star | [ star ].concat star.connections }
		
		##
		# Append an asteroid to each cluster
		#  
		asteroids = []
		clusters.each do | c |
		
			# Create a planet and a path, so decrease these
			num_asteroids -= 1
			num_paths -= 1
			
			# Create the asteroid and the path
			cluster_object = c[ rand c.length ]
			asteroid = Asteroid.new( bytes ENTROPY )
			path = SpacePath.new cluster_object, asteroid, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
			
			# Connect the path
			cluster_object.connect path
			asteroid.connect path
			
			# Register the node
			asteroids.push( { :asteroid => asteroid, :cluster => c } )
			nodes.push asteroid
		end
		
		##
		# A part of the asteroids is sparse!
		#
		sparse_asteroids = num_asteroids / universe[ :dice ][ :sparse_asteroid ].to_f
		sparse_variance = sparse_asteroids / 100 * universe[ :variance ]
		sparse_asteroids = ( sparse_asteroids + rand( sparse_variance ) - sparse_variance  / 2.to_f ).round
		num_asteroids -= sparse_asteroids
		
		##
		# Please disparse my asteroids
		#
		while num_asteroids > 0
			asteroids.each do | meta_a |

				asteroid = meta_a[ :asteroid ]
				
				# Create an asteroid and a path, so decrease these
				num_asteroids -= 1
				num_paths -= 1
				
				# Create the asteroid and the path
				new_asteroid = Asteroid.new( bytes ENTROPY )
				path = SpacePath.new new_asteroid, asteroid, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
		
				# Connect the path
				new_asteroid.connect path
				asteroid.connect path
				
				# Add the old asteroid to the cluster
				meta_a[ :cluster ].push asteroid
				meta_a[ :asteroid ] = new_asteroid
				
				# Register the node
				nodes.push new_asteroid
				
				# Connect to a cluster
				if num_asteroids > 0 and rand( 100 ) < ( clusters.length / num_asteroids * 100 )
					
					# Find the clusters that are being connected
					cluster = clusters[ rand clusters.length ]
					connectee = cluster[ rand cluster.length ]
					
					# Create a path between the asteroid and the cluster
					num_paths -= 1
					path = SpacePath.new connectee, new_asteroid, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
			
					# Connect the path
					connectee.connect path
					new_asteroid.connect path
					
					# Delete the old clusters
					clusters.delete cluster
					clusters.delete meta_a[ :cluster ]
					
					# Create the new cluster
					clusters.push( cluster.concat( meta_a[ :cluster ] ).push new_asteroid )					
				end
			end
		end
		
		##
		# Lets make sure all the clusters are connected!
		#
		while clusters.length > 1
			
			# Find the clusters that are being connected
			left_cluster = clusters[ rand clusters.length ]
			options = clusters.select { | c | c != left_cluster }
			right_cluster = options[ rand options.length ]
			
			# Find the nodes to connect
			left_nodes = left_cluster.select { | n | !n.is_a? Star }
			right_nodes = right_cluster.select { | n | !n.is_a? Star }
			left_node = left_nodes[ rand left_nodes.length ]
			right_node = right_nodes[ rand right_nodes.length ]
			
			# Create a path between the clusters
			num_paths -= 1
			path = SpacePath.new left_node, right_node, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
	
			# Connect the path
			left_node.connect path
			right_node.connect path
			
			clusters.delete left_cluster
			clusters.delete right_cluster
			clusters.push( left_cluster.concat right_cluster )
		end
		
		##
		# Now process the sparse_asteroids
		#
		while sparse_asteroids > 0
		
			cluster = clusters.first
			cluster_object = cluster[ rand cluster.length ]
			
			# Create an asteroid and a path, so decrease these
			sparse_asteroids -= 1
			num_paths -= 1
			
			# Create the asteroid and the path
			asteroid = Asteroid.new( bytes ENTROPY )
			path = SpacePath.new asteroid, cluster_object, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
	
			# Connect the path
			cluster_object.connect path
			asteroid.connect path
			
			# Register this asteroid
			cluster.push asteroid
			nodes.push asteroid
		end
				
		skip = []
		##
		# Do we still need to make some faces?
		#
		while num_paths > 0 and clusters.first.length > skip.length
		
			options = []
			visited = []
			
			# Get the left object
			cluster = clusters.first.select { | n | n.is_a? Asteroid and !skip.include? n }
			left_object = cluster[ rand cluster.length ]
			skip.push left_object
			
			# Start travelling!
			travelling = universe[ :distances ][ :connecting ]
			recursive_traverse( travelling, left_object, options, visited )
			options = options.select { |n| n != left_object and !n.connections.include?( left_object ) }
			
			if options.length === 0
				next
			end
			
			# Right object
			right_object = options[ rand options.length ]
			
			# Create the path
			num_paths -= 1
			path = SpacePath.new left_object, right_object, rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
	
			# Connect the path
			left_object.connect path
			right_object.connect path
			
		end
		
		processed = []
		digraph do
		
			node_attribs << filled
							
			nodes.each do |node|
				
				node.paths.each { |p| 
				
					if processed.include? p
						next
					end
					processed.push p
					
					edge node, p[ :to ]
					
					if node.is_a? Star
						darkgoldenrod << node( node )
					elsif node.is_a? Planet
						limegreen << node( node )
					elsif node.is_a? Asteroid
						lightslategray << node( node )
					end
				}
			end

			save 'graph', 'png'
		end
		
		log "The Universe has been created"

	end
	
	##
	# Builds the seed for this universe
	# 
	def build_seed( seed_string )
		result = ""
		seed_string.each_byte { | ord | result += ord.to_s }
		return result.to_i % ( 2 ** 32 ) 
	end	
	
	def recursive_traverse( travelling, node, endpoints, visited )
	
		if travelling < 0
			return
		end
		
		visited.push node
		endpoints.push node if node.is_a? Asteroid
		node.paths.each { |p| 
			if visited.include? p[ :to ]
				next
			end
			recursive_traverse( travelling - p[ :distance ], p[ :to ], endpoints, visited )
		}
	end
end

a = Space.new( { :secrets => [ 'foo', 'bar' ], :universe => { :size => 64 } } )
puts a.birthdate
Space.freeze