Dir[ File.join( File.dirname(__FILE__), 'interface', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'generator', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'env', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), '../crew', '*.rb' )].each { |file| require file }

require_relative 'runner.instance'

class RubiesInSpaceRunner
	
	attr_reader :players, :universe, :instance
	
	##
	# Intialize the runner with a generator and options
	#
	def initialize( generator = Generators::Universe::Basic, options = { :universe => { :size => 32 } } )
		
		@generator = generator
		@options = options
		@players = []
		@runner = create_simulation
		@instance = Instance.new
	end
	
	##
	#
	#
	def with( foo )
		if foo.is_a? Hash
			with_options foo
		elsif foo.is_a? Class
			with_generator foo
		end
	end
	
	##
	#
	#
	def with_options( foo )
		@options = foo
		return true
	end
	
	##
	#
	#
	def with_generator( foo )
		return false unless foo.respond_to?( :new )
		bar = foo.new
		return false unless bar.respond_to?( :build )
		return false if bar.method( :build ).parameters.length != 1
		@generator = bar
		return true
	end
	
	##
	# Join a crew to the space
	#
	def join( crew )
		
		unless crew.respond_to?( 'new' )
			raise "Can't instantiate that crew"
		end
		
		if @instance.created?
			raise "Can't join after creation"
		elsif @instance.active?
			raise "Can't join while running"
		end
		
		@players.push Player.new( crew )
	end
	
	##
	# Create everything
	#
	def create
		
		@options[ :secrets ] = @players.map { | p | p.secret }
		@universe = @generator.build @options 
		
		Space::Universe.log "\r\nSpawning players"
		
		@players.each do | p | 
			p.spawn( 
				@universe.node( 
					@universe.get_spawn_node 
				) 
			)
			#p.spawn( 
			#	@universe.node( 
			#		@universe.get_spawn_node 
			#	)
			#)
		end
		@instance.universe = @universe
		@instance.players = @players.clone
		@instance.create
	end	
	
	##
	#
	#
	def create_simulation
	
		Thread.new do
			
			Thread.stop
			
			Space::Universe.log "\r\nSimulation started"
			actions = []
			
			bm = Benchmark.measure do
				loop do

					@instance.step += 1
					
					##
					# Step all the players that are not busy
					#
					actions = ( actions + ( @instance.players.map { | player | player.step @instance.step } ) ).flatten
					
					##
					# Process all the actions we have
					#
					actions = actions.sort_by { Space::Universe.rand }.select { | action | 
						action[ :action ] != nil and ( action[ :state ] = action[ :player ].process( 
							@instance.step, action[ :ship ], action[ :action ], action[ :time ], action[ :state ] 
						) ) != :kill
					}
					
					##
					# Goodbye players that are deaaad
					#
					@instance.players = @instance.players.select { | player | if player.dead? then puts "\r\n~~~ #{player} died! ~~~"; false; else true end }
					
					if @instance.step == 1000000 or @instance.players.length <= 1 or not @instance.active?
						puts "", "STOPPPP", ""
						break
					end
					
					if Thread.current[ :pause ]
						Thread.current[ :pause ] = false
						Thread.stop
					end
				end
			end
			
			puts ""
			Space::Universe.log "Simulation ended at #{ Space::Universe.stardate @instance.step } / #{ bm } / #{ @instance.players.length  } standing"
			
			@instance.abort
			@runner = create_simulation
			
			@instance.step
		end
	end
	
	##
	#
	#
	def simulate
		
		if !@instance.run
			return false
		end
	
		@runner.run
	end
	
	##
	#
	#
	def pause
		if @instance.pause
			@runner[ :pause ] = true
			return true
		end
		return false
	end
	
	##
	#
	#
	def resume
		if @instance.resume
			@runner.run
			return true
		end
		return false
	end
	
	##
	#
	#
	def abort
		if @instance.running?
			@instance.abort
		end
	end
end