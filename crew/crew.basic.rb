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
			Space.timestamped t, @last_result
			
			if @ship.result.is_a? ScanResult
				current = @ship.position
				
				if @ship.energy_ratio < 0.8 and !@ship.result.environment[ :deuterium ].nil? and not @ship.result.environment[ :deuterium ] <= 0
					
					puts @ship.result.environment[ :deuterium ]
					@ship.queue @ship.collect [ @ship.result.environment[ :deuterium ], @ship.energy_capacity - @ship.energy ].min + 20
					
				else
				
					others = @ship.result.paths.map { |p| p[ :alpha ] == current ? p[ :beta ] : p[ :alpha ] }.select{ |d| !@visited.include?( d ) }
					return if others.length == 0
					
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