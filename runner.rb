Dir[ File.join( File.dirname(__FILE__), 'interface', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'generator', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'env', '*.rb' )].each { |file| require file }
Dir[ File.join( File.dirname(__FILE__), 'crew', '*.rb' )].each { |file| require file }

class RubiesInSpaceRunner
	
	##
	# Intialize the runner with a generator and options
	#
	def initialize( generator = BasicSpaceGenerator, options = { :universe => { :size => 16 } } )
		
		@generator = generator
		@options = options
		@players = []
		
		join BasicCrew
		join BasicCrew
		
		create
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
		
		#Thread
		loop do
		
			@step += 1
				
				
			break if @step == 100
		end
		
		Space.log "Die"
		
	end
	
end

RubiesInSpaceRunner.new