Dir[ File.join( File.dirname(__FILE__), 'interface', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'generator', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'env', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'crew', '*.rb' )].each { |file| require file }

class RubiesInSpaceRunner
	
	##
	# Intialize the runner with a generator and options
	#
	def initialize( generator = BasicSpaceGenerator, options = { :universe => { :size => 128 } } )
		
		@generator = generator
		@options = options
		@players = []
		
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
	def create()
		
		@options[ :secrets ] = @players.map { | p | p.secret }
		@space = @generator.build @options 
		
		Space.log "\r\nSpawning players"
		
		@players.each do | p | 
			p.spawn( 
				@space.node( 
					@space.get_spawn_node 
				) 
			)
		end
	end	
	
	##
	#
	#
	def simulate()
		
		@step = 0
		
		Space.log "\r\nSimulation started"
		
		#Thread
		loop do
			
			@step += 1
			
			players = @players.clone
			players.each do | p |
				p.step @step
			end
			
			players.each do | p |
				p.process @step
			end
			
			players.each do | p |
				@players.delete p if p.dead?
			end
	
			break if @step == 500000 or @players.length == 0
		end
		
		Space.log "Simulation ended at #{ Space.stardate @step }"
		
	end
	
end

RubiesInSpaceRunner.new