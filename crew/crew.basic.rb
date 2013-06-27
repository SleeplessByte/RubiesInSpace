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
				others = @ship.result.paths.map { |p| p[ :alpha ] == current ? p[ :beta ] : p[ :alpha ] }.select{ |d| !@visited.include?( d ) }
				return if others.length == 0
				
				@ship.queue @ship.travel( others[ Space.rand others.length ] )
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