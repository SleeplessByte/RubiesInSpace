class BasicCrew

	#
	#
	def identifier
		"MyBasicCrew 1.0.0"
	end
	
	def initialize
		@last_result = nil
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
		end
		
	end
	
	#
	#
	def event( event )
	
	end
	
end