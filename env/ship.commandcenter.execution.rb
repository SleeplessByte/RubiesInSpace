require_relative 'ship.commandcenter'

#
#
class Ship

	#
	#
	class CommandCenter < Component
		
		# TODO variance
		# TODO tech
	
		##
		#
		#
		def request_scan( t, action )
			execution = ship.scanner.execute( t, action )
			
			set_duration execution[ :duration ]
			@action_result = execution[ :result ]
			return :continue
		end
		
		##
		#
		#
		def request_travel( t, action )
						
			path = @location.paths.find { |p| p[ :to ].identifier == action.node }
			unless path
				set_duration 1
				progress
				@action_result = nil
				return :kill
			end
				
			execution = ship.engine.prepare( t, action, path )
			set_duration execution[ :duration ]
			@action_result = execution[ :result ]
			return :pre
		end
		
		##
		#
		#
		def pre_travel( t, action )

			return :kill if progress

			if progress_duration > ship.engine.warmup 
				
				path = @location.paths.find { |p| p[ :to ].identifier == action.node }
				unless path
					set_duration 1
					progress
					@action_result = nil
					return :kill
				end
				
				leave
				travel( path[ :to ] )
				return :continue
			end
			
			return :pre
		end
		
		##
		#
		#
		def continue_travel( t, action )
			return :post if progress
			
			execution = ship.reactor.fly( t, action )
			@action_result.depletion = @action_result.depletion + execution[ :depletion ]
			
			flight_duration = @action_result.duration - ship.engine.warmup - ship.engine.cooldown
			current_flight = progress_duration - ship.engine.warmup
			if current_flight >= flight_duration
				join
				return :post
			end
			
			return :continue
		end
		
		##
		#
		#
		def post_travel( t, action )
			if progress
				@action_result.finalize
				return :kill
			end
			return :post
		end
		
		##
		#
		#
		def request_collect( t, action )
			execution = ship.collector.request( t, action )
			set_duration execution[ :duration ]
			@action_result = execution[ :result ]
			return :continue
		end
		
		##
		#
		#
		def continue_collect( t, action )
			
			if progress_duration > ship.collector.warmup
				execution = ship.collector.execute( t, action )
				collection = execution[ :collected ]			
				@action_result.collected = @action_result.collected + collection
			end
			
			if progress
				@action_result.finalize
				return :kill
			end
			
			return :continue
		end
		
		##
		#
		#
		def request_attack( t, action )
		
			attackee = @location.ships.find { |s| s.identifier == action.destination }
			unless attackee
				set_duration 1
				progress
				@action_result = nil
				return :kill 
			end
			
			execution = ship.weapons_rack.prepare( t, action, attackee )
			set_duration execution[ :duration ]
			@action_result = execution[ :result ]
			return :pre
		end
		
		##
		#
		#
		def pre_attack( t, action )
			
			attackee = @location.ships.find { |s| s.identifier == action.destination }
			unless attackee
				set_duration 1
				progress
				@action_result.finalize
				return :kill 
			end
			
			if progress
				set_duration 1
				return :continue
			end
			return :pre
		end
		
		##
		#
		#
		def continue_attack( t, action )
			attackee = @location.ships.find { |s| s.identifier == action.destination }
			unless attackee
				set_duration 1
				progress
				@action_result.finalize
				
				puts "", "#{ action.destination } is no longer at #{ ship } position"
				return :kill 
			end
		
		    # Attack!
			execution = ship.weapons_rack.fire( t, action, attackee )
			@action_result.damage = execution[ :damage ]
			@action_result.depletion = execution[ :depletion ]
			
			if attackee.dead?
				puts "", "#{ attackee } was killed in battle by #{ ship }"
			end
			
			# Get the event result to abort
			result = ship.event( execution[ :event ] )
			unless result
				set_duration 1
				progress
				@action_result.finalize
				return :kill
			end
			return :continue
		end
		
	end
end