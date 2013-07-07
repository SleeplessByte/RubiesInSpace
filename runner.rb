Dir[ File.join( File.dirname(__FILE__), 'interface', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'generator', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'env', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'crew', '*.rb' )].each { |file| require file }

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
		@instance.players = @players.clone
		@instance.create
	end	
	
	##
	#
	#
	def create_simulation
	
		Fiber.new do |instance|
		
			actions = []
		
			loop do
			
				instance.step += 1
				
				##
				# Step all the players that are not busy
				#
				actions = ( actions + ( instance.players.map { | player | player.step instance.step } ) ).flatten
				
				##
				# Process all the actions we have
				#
				actions = actions.sort_by { Space::Universe.rand }.select { | action | 
					action[ :action ] != nil and ( action[ :state ] = action[ :player ].process( 
						instance.step, action[ :ship ], action[ :action ], action[ :time ], action[ :state ] 
					) ) != :kill
				}
				
				##
				# Goodbye players that are deaaad
				#
				instance.players = instance.players.select { | player | if player.dead? then puts "\r\n~~~ #{player} died! ~~~"; false; else true end }
		
				break if instance.step == 1000000 or instance.players.length <= 1 or not instace.active?
				Fiber.yield instance.step if instance.paused?
			end
			
			instance.step
		end
	end
	
	##
	#
	#
	def simulate
		
		@instance.run
		puts @instance.step
		
		Space::Universe.log "\r\nSimulation started"

		bm = Benchmark.measure do
			@runner.resume @instance
		end

		puts ""
		Space::Universe.log "Simulation ended at #{ Space::Universe.stardate @instance.step } / #{ bm } / #{ @instance.players.length  } standing"
		
		@instance.abort
	end
	
	##
	#
	#
	def pause
		return @instance.pause
	end
	
	##
	#
	#
	def resume
		if @instance.resume
			@runner.resume @instance
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
		
	class Instance
		attr_accessor :step, :players
		attr_reader :state
		
		def running?
			@state === :running
		end
		
		def aborted?
			@state === :aborted
		end
		
		def paused?
			@state === :paused
		end
		
		def created?
			@state === :created
		end
		
		def active?
			paused? or running?
		end
		
		def create
			@state = :created
		end
		
		def abort
			@state = :abort
		end
		
		def run
			if created?
				@state = :running
				@step = 0
				return true
			end
			return false
		end
		
		def pause
			if running?
				@state = :pause
				return true
			end
			return false
		end
		
		def resume
			if paused?
				@state = :resume
				return true
			end
			return false
		end
	end
end