class BasicCrew

	#
	#
	def identifier
		"MyBasicCrew 1.0.0"
	end
	
	#
	#
	def initialize
		@last_result = nil
		@visited = []
	end
	
	#
	#
	def board( ship )
		@ship = ship
		@ship.queue @ship.scan()
	end
	
	#
	#
	def step( t )
		
		if @last_result != @ship.result
			@last_result = @ship.result
			puts "\r\n\r\n                ----------------------------------------------                \r\n"
			Space.timestamped t, @last_result
			puts "                ----------------------------------------------                \r\n\r\n"
			
			if @ship.result.is_a? ScanResult
				current = @ship.position
				
				if @ship.energy_ratio < 0.8 and ( @ship.result.environment[ :type ] == Star or ( !@ship.result.environment[ :deuterium ].nil? and not @ship.result.environment[ :deuterium ] <= 20 ) )
				
					env_deut = @ship.result.environment[ :deuterium ] || @ship.energy_capacity
					@ship.queue @ship.collect [ env_deut , @ship.energy_capacity - @ship.energy ].min + 20
					
				else
				
					connections = @ship.result.paths.map { |p| p[ :alpha ] == current ? p[ :beta ] : p[ :alpha ] }
					others = connections.select{ |d| !@visited.include?( d ) }
					if others.length == 0
						Space.timestamped t, "\r\n\r\n==========================\r\nI have nowhere to go. #{ @ship }\r\n==========================\r\n\r\n"
						
						@visited = [ @ship.position ]
						@ship.queue @ship.scan()
						return
					end
					
					@ship.queue @ship.travel( others[ Space.rand others.length ] )
				end
			else
				@visited.push @ship.position
				@ship.queue @ship.scan()
			end
		end
		
	end
	
	#
	#
	def event( event )
	
	end
	
end