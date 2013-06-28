Dir[ File.join( File.dirname(__FILE__), 'interface', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'generator', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'env', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'crew', '*.rb' )].each { |file| require file }

class RubiesInSpaceRunner
	
	##
	# Intialize the runner with a generator and options
	#
	def initialize( generator = BasicSpaceGenerator, options = { :universe => { :size => 8 } } )
		
		@generator = generator
		@options = options
		@players = []
		
		join BasicCrew
		join BasicCrew
		join BasicCrew
		
		create
		simulate
	end
	
	##
	# Join a crew to the space
	#
	def join( crew )
		
		unless crew.respond_to?( 'new' )
			raise "Can't instantiate that crew"
		end
		
		@players.push Player.new( crew )
	end
	
	##
	# Create everything
	#
	def create
		
		@options[ :secrets ] = @players.map { | p | p.secret }
		@space = @generator.build @options 
		
		Space.log "\r\nSpawning players"
		
		@players.each do | p | 
			p.spawn( 
				@space.node( 
					@space.get_spawn_node 
				) 
			)
			p.spawn( 
				@space.node( 
					@space.get_spawn_node 
				)
			)
		end
		@active_players = @players.clone
	end	
	
	##
	#
	#
	def simulate
		
		@step = 0
		
		Space.log "\r\nSimulation started"
		actions = []
		
		bm = Benchmark.measure do
			
			loop do
				
				@step += 1
				
				##
				# Step all the players that are not busy
				#
				actions = ( actions + ( @active_players.map { | player | player.step @step } ) ).flatten
				
				##
				# Process all the actions we have
				#
				actions = actions.sort_by { Space.rand }.select { | action | 
					action[ :action ] != nil and ( action[ :state ] = action[ :player ].process( 
						@step, action[ :ship ], action[ :action ], action[ :time ], action[ :state ] 
					) ) != :kill
				}
				
				##
				# Goodbye players that are deaaad
				#
				@active_players = @active_players.select { | player | if player.dead? then puts "\r\n~~~ #{player} died! ~~~"; false; else true end }
		
				break if @step == 1000000 or @active_players.length <= 1
			end
			
		end
		
		
		
		puts ""
		Space.log "Simulation ended at #{ Space.stardate @step } / #{ bm } / #{ @active_players.length  } standing"
		
	end
	
end

RubiesInSpaceRunner.new