require_relative '../env/space'
require 'graph'

##
# This is space. This is where the rubies are!
class BasicSpaceGenerator
	
	##
	#
	#
	VERSION  = '1.0.0'
	
	## 
	#
	#
	def self.size( universe )
		
		results = {}
		
		results[ :n ] = universe[ :size ]
		results[ :f ] = results[ :n ] / universe[ :connectivity ][ :faces ].to_f
		face_variance = results[ :f ] / 100.to_f * universe[ :variance ]
		results[ :f ] = ( results[ :f ] + Space.rand( face_variance ) - face_variance / 2.to_f ).round
		results[ :p ] = results[ :n ] + results[ :f ] - 1
		
		return results
	end
	
	##
	#
	#
	def self.contents( universe, universe_size )
	
		results = {}
		
		results[ :stars ] = universe_size[ :n ] / universe[ :ratios ][ :stars ].to_f
		results[ :planets ]  = universe_size[ :n ] / universe[ :ratios ][ :planets ].to_f
		star_variance = results[ :stars ] / 100.to_f * universe[ :variance ]
		planet_variance = results[ :planets ]  / 100.to_f * universe[ :variance ]
		
		results[ :stars ] = ( results[ :stars ] + Space.rand( star_variance ) - star_variance  / 2.to_f ).round
		results[ :planets ] = ( results[ :planets ]  + Space.rand( planet_variance ) - planet_variance / 2.to_f ).round
		results[ :asteroids ] = universe_size[ :n ] - results[ :stars ] - results[ :planets ] 
		
		return results
	end

	def self.create_star( nodes,  universe, universe_size, universe_contents )
	
		if universe_contents[ :stars ] <= 0
			raise "I can't allow more stars in this universe."
		end
		
		if universe_size[ :n ] <= 0
			raise "This universe is full."
		end
		
		universe_size[ :n ] -= 1
		universe_contents[ :stars ] -= 1
		result = Star.new( Space.bytes Space::ENTROPY )
		
		nodes.push result
		
		return result
	end
	
	def self.create_planet( nodes, universe, universe_size, universe_contents )
	
		if universe_contents[ :planets ] <= 0
			raise "I can't allow more planets in this universe."
		end
		
		if universe_size[ :n ] <= 0
			raise "This universe is full."
		end
		
		universe_size[ :n ] -= 1
		universe_contents[ :planets ] -= 1
		result = Planet.new( Space.bytes Space::ENTROPY )
		
		nodes.push result
		
		return result
	end
	
	def self.create_asteroid( nodes, universe, universe_size, universe_contents )
	
		if universe_contents[ :asteroids ] <= 0
			raise "I can't allow more asteroids in this universe."
		end
		
		if universe_size[ :n ] <= 0
			raise "This universe is full."
		end
		
		universe_size[ :n ] -= 1
		universe_contents[ :asteroids ] -= 1
		result = Asteroid.new( Space.bytes Space::ENTROPY )
		
		nodes.push result
		
		return result
	end
	
	def self.create_path( left, right, universe, universe_size )
	
		if universe_size[ :p ] <= 0
			raise "This universe is overly connected."
		end
		
		universe_size[ :p ] -= 1
		
		result = SpacePath.new left, right, Space.rand( universe[ :distances ][ :max ] - universe[ :distances ][ :min ] ) + universe[ :distances ][ :min ]
		left.connect result
		right.connect result
			
		return result
	end
	
	##
	# Lets make stars our cluster centers
	#
	def self.create_clusters( nodes, universe, universe_size, universe_contents )
		
		if universe_contents[ :stars ] <= 0
			raise ArgumentError "I can't create a universe that small."
		end
		
		clusters = []
		universe_contents[ :stars ].times do
			clusters.push create_star( nodes, universe, universe_size, universe_contents )
		end

		return clusters
	end
	
	##
	# Some stars are lonely in their cluster. Let's find the cosy stars
	# because they will inherit all the planets, leaving the lonely star 
	# very lonely.
	#
	def self.get_cosy_stars( nodes, universe )
		
		results = nodes.select { |star| Space.rand( universe[ :dice ][ :lonely_star ] ) > 0 }
		results.push nodes.first() if results.length == 0

		return results
	end
	
	##
	# Cosy stars have at least one planet
	#
	def self.populate_cosy_stars( nodes, cosy_stars, universe, universe_size, universe_contents )
		
		cosy_stars.each do | star |
			planet = create_planet( nodes, universe, universe_size, universe_contents )
			path = create_path( planet, star, universe, universe_size )
		end
		
		universe_contents[ :planets ].times do 
			star = cosy_stars[ Space.rand cosy_stars.length ]
			planet = create_planet( nodes, universe, universe_size, universe_contents )
			path = create_path( planet, star, universe, universe_size )
		end
		
	end
	
	##
	# We created clusters of planets surrounding stars, so lets select those
	#
	def self.get_extended_clusters( clusters )
		return clusters.map { | star | [ star ].concat star.connections }
	end
	
	##
	# Append an asteroid to each cluster
	#  
	def self.give_clusters_an_asteroid( nodes, clusters, universe, universe_size, universe_contents )
	
		results = []
		clusters.each do | c |
			
			# Create the asteroid and the path
			cluster_object = c[ Space.rand c.length ]
			asteroid = create_asteroid( nodes, universe, universe_size, universe_contents )
			path = create_path( asteroid, cluster_object, universe, universe_size )
	
			results.push( { :asteroid => asteroid, :cluster => c } )
		end
		
		return results
	end
	
	##
	# A part of the asteroids is sparse!
	#
	def self.assign_sparse_asteroids( universe, universe_contents )
		
		universe_contents[ :sparse_asteroids ] = universe_contents[ :asteroids ] / universe[ :dice ][ :sparse_asteroid ].to_f
		sparse_variance = universe_contents[ :sparse_asteroids ] / 100 * universe[ :variance ]
		universe_contents[ :sparse_asteroids ] = ( universe_contents[ :sparse_asteroids ] + Space.rand( sparse_variance ) - sparse_variance  / 2.to_f ).round
		universe_contents[ :asteroids ] -= universe_contents[ :sparse_asteroids ]
		
		return universe_contents[ :sparse_asteroids ]
	end
	
	##
	#
	#
	def self.interconnect_clusters_with_asteroids( nodes, asteroids, clusters, universe, universe_size, universe_contents )
		
		total = universe_contents[ :asteroids ] 
		
		while universe_contents[ :asteroids ] > 0
			asteroids.each do | meta_a |
			
				asteroid = meta_a[ :asteroid ]
				cluster = meta_a[ :cluster ]
				
				# Create the asteroid and the path
				new_asteroid = create_asteroid( nodes, universe, universe_size, universe_contents )
				path = create_path( new_asteroid, asteroid, universe, universe_size )
				
				# Add the old asteroid to the cluster
				cluster.push asteroid
				meta_a[ :asteroid ] = new_asteroid
				
				# Connect to a cluster
				if universe_contents[ :asteroids ] > 0 
				
					if Space.rand( 100 ) < ( clusters.length / universe_contents[ :asteroids ] * 100 )
						connect_clusters( new_asteroid, cluster, clusters, universe, universe_size, universe_contents )
					end
				else
					break
				end
				
				percentage_log( ( total - universe_contents[ :asteroids ] ) / total.to_f * 100, "Interconnect clusters with asteroids" )
			end
		end
	end
	
	##
	#
	#
	def self.connect_clusters( asteroid, asteroid_cluster, clusters, universe, universe_size, universe_contents )
		cluster = clusters[ Space.rand clusters.length ]
		connectee = cluster[ Space.rand cluster.length ]
		
		path = create_path( connectee, asteroid, universe, universe_size )

		clusters.delete cluster
		clusters.delete asteroid_cluster
		clusters.push( ( cluster + asteroid_cluster ).push asteroid )					
	end
	
	##
	# Lets make sure all the clusters are connected!
	#
	def self.ensure_connected_clusters( clusters, universe, universe_size )
	
		total = clusters.length
		while clusters.length > 1
			
			# Find the clusters that are being connected
			left_cluster = clusters[ Space.rand clusters.length ]
			options = clusters.select { | c | c != left_cluster }
			right_cluster = options[ Space.rand options.length ]
			
			# Find the nodes to connect
			left_nodes = left_cluster.select { | n | !n.is_a? Star }
			right_nodes = right_cluster.select { | n | !n.is_a? Star }
			left_node = left_nodes[ Space.rand left_nodes.length ]
			right_node = right_nodes[ Space.rand right_nodes.length ]
			
			path = create_path( left_node, right_node, universe, universe_size )
			
			clusters.delete left_cluster
			clusters.delete right_cluster
			clusters.push( left_cluster + right_cluster )
			
			percentage_log( ( total - clusters.length ) / total.to_f * 100, "Ensure connected clusters" )
		end
		
	end
	
	##
	# Now process the sparse_asteroids
	#
	def self.connect_sparse_asteroids( nodes, clusters, universe, universe_size, universe_contents )
		universe_contents[ :asteroids ] += universe_contents[ :sparse_asteroids ]
		
		total = universe_contents[ :asteroids ]
		while universe_contents[ :asteroids ] > 0
		
			cluster = clusters.first
			cluster_object = cluster[ Space.rand cluster.length ]
			
			asteroid = create_asteroid( nodes, universe, universe_size, universe_contents )
			path = create_path( asteroid, cluster_object, universe, universe_size )
			
			cluster.push asteroid
			
			percentage_log( ( total -  universe_contents[ :asteroids ] ) / total.to_f * 100, "Connecting sparse asteroids" )
		end
	end
	
	##
	# Do we still need to make some paths?
	#
	def self.overconnect_close_nodes( clusters, universe, universe_size )
	
		total = universe_size[ :p ]
		overless_connected = clusters.first.select { | n | n.is_a? Asteroid }
		while universe_size[ :p ] > 0 and overless_connected.length > 0
		
			options = []
			visited = []
			
			# Get the left object
			left_object = overless_connected[ Space.rand overless_connected.length ]

			# Start travelling!
			travelling = universe[ :distances ][ :connecting ]
			recursive_traverse( travelling, left_object, options, visited )
			options = options.select { |n| n != left_object and !n.connections.include?( left_object ) }
			
			if options.length === 0
				overless_connected.delete left_object
				next
			end
			
			# Right object
			right_object = options[ Space.rand options.length ]
			path = create_path( left_object, right_object, universe, universe_size )
			
			percentage_log( ( total - universe_size[ :p ] ) / total.to_f * 100, "Overconnecting close nodes" )
		end
		
	end
	
	def self.percentage_log( percentage, message )
		print "\r                                                            \r"
		print "\r#{message}: #{percentage.round}%"
	end
	
	##
	# Creates space from a set of options
	#
	def self.build( options )
		Space.log "Creation of the Universe has started with #{ options }"

		##
		#
		#
		results = Space.new( options )
		universe = results.configuration
		universe_size = size( universe )
		universe_contents = contents( universe, universe_size )

		Space.log "Developing #{  universe_contents[ :stars ] } stars, mending #{  universe_contents[ :planets ] } planets, throwing #{  universe_contents[ :asteroids ] } asteroids, " +
			"totalling in #{ universe_size[ :n ] } nodes with #{ universe_size[ :f ] } faces and #{ universe_size[ :p ] } paths"

		nodes = []
		groups = {}
		
		# Intial clustering
		groups[ :clusters ] = create_clusters( nodes, universe, universe_size, universe_contents )
		groups[ :cosy_stars ] = get_cosy_stars( nodes, universe )
		populate_cosy_stars( nodes, groups[ :cosy_stars ], universe, universe_size, universe_contents )
		
		# Add a connection point
		groups[ :extended_clusters ] = get_extended_clusters( groups[ :clusters ] )
		groups[ :asteroids ] = give_clusters_an_asteroid( nodes, groups[ :extended_clusters ], universe, universe_size, universe_contents )
		assign_sparse_asteroids( universe, universe_contents )
		
		# Connect those asteroids
		interconnect_clusters_with_asteroids( nodes, groups[ :asteroids ], groups[ :extended_clusters ], universe, universe_size, universe_contents )
		ensure_connected_clusters(  groups[ :extended_clusters ], universe, universe_size )		
		connect_sparse_asteroids( nodes, groups[ :extended_clusters ], universe, universe_size, universe_contents )
		overconnect_close_nodes( groups[ :extended_clusters ], universe, universe_size )
		
		print "\r                                                            \r"
		Space.log "The Universe has been created"
		results.fill nodes
		
		return results
	end

	def self.recursive_traverse( travelling, node, endpoints, visited )
	
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