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
		@command_center = @ship.command_center
		@command_center.queue @command_center.scan_command()
	end
	
	#
	#
	def step( t )
		
		if @last_result != @ship.report
			@last_result = @ship.report
			puts "\r\n\r\n                ----------------------------------------------                \r\n"
			Space.timestamped t, @last_result
			puts "                ----------------------------------------------                \r\n\r\n"
			
			if @last_result.is_a? ShipInterface::ScanReport
				current = @ship.position
				
				if @ship.energy_ratio < 0.8 and ( @last_result.environment[ :type ] == Star or ( !@last_result.environment[ :deuterium ].nil? and not @last_result.environment[ :deuterium ] <= 20 ) )
				
					env_deut = @last_result.environment[ :deuterium ] || @ship.energy_capacity
					@command_center.queue @command_center.collect_command( [ env_deut , @ship.energy_capacity - @ship.energy ].min + 20 )
					
				else
				
					connections = @last_result.paths.map { |p| p[ :alpha ] == current ? p[ :beta ] : p[ :alpha ] }
					others = connections.select{ |d| !@visited.include?( d ) }
					if others.length == 0
						Space.timestamped t, "\r\n\r\n==========================\r\nI have nowhere to go. #{ @ship }\r\n==========================\r\n\r\n"
						
						@visited = [ @ship.position ]
						@command_center.queue @command_center.scan_command()
						return
					end
					@command_center.queue @command_center.travel_command( others[ Space.rand others.length ] )
				end
			else
				@visited.push @ship.position
				@command_center.queue @command_center.scan_command()
			end
		end
		
	end
	
	#
	#
	def event( event )
	
	end
	
end