helpers do
	def username
		session[ :identity ] ? 'Hello ' + session[ :identity ] : 'Hello stranger'
	end
	
	def simstate
		'<a href="/simulation">' + simstate_text + '</a>'
	end
	
	def can_configure?
		@snapshot.state.nil? || @snapshot.aborted?
	end
	
	def can_simulate?
		@snapshot.created?
	end
	
	def can_simulate_pause?
		@snapshot.running?
	end
	
	def can_simulate_resume?
		@snapshot.paused?
	end
	
	def can_simulate_abort?
		@snapshot.running?
	end
	
	def simstate_text
		if @snapshot.created?
			return 'waiting to start'
		elsif @snapshot.paused?
			return 'paused'
		elsif @snapshot.running?
			return 'running'
		elsif @snapshot.aborted?
			return 'stopped'
		end
		return 'non existant'
	end
	
	def try_adding_player( params )
		return false if params[ :crew ].nil? or not params[ :crew ].length
		begin
			$runner.join( Crews.const_get( params[ :crew ] ) )
			return true
		end
	end
	
	def try_setting_simulation( params )
		return false unless params[ :simulate ]
		action = params[ :simulate ].keys.first
		method = ( 'try_' + action + '_simulation' ).to_sym
		return false unless respond_to?( method )
		send( method )
		return true
	end
	
	def try_generate_simulation()
		$runner.create
	end
	
	def try_start_simulation()
		$runner.simulate
	end
	
	def try_pause_simulation()
		$runner.pause
	end
	
	def try_resume_simulation()
		$runner.resume
	end
	
	def try_abort_simulation()
		$runner.abort
	end
	
	def get_crews
		Crews.constants.map do |crew|
			Crews.const_get crew
		end
	end
	
	def menu_li( route, text )
		link = '<a href="' + route + '">' + text + '</a>'
		if route == request.path_info
			return '<li class="active">' + link + '</li>'
		end
		return '<li>' + link + '</li>'
	end
end