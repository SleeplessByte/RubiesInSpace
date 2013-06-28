require_relative 'ship.component'

#
#
class Ship
	
	#
	#
	class CommandCenter < Component
		
		def initialize( ship )
			super ship

			@location = nil
			@actions = [ nil ]
			@action_progression = 1		
			@action_result = nil
			@action_killed = false
		end
		
		##
		# Gets the current action
		#
		def current
			@actions[ 0 ]
		end

		##
		# Gets the next action
		#
		def next
			@actions[ 1 ]
		end
		
		##
		# Gets the current action queue
		#
		def queue( action )
			@actions.push action
		end
		
		##
		# Advances the action queue
		#
		def advance
			@action_killed = false
			action = @actions.shift
			@actions = [ nil ] if @actions.empty?
			return action
		end
		
		##
		# Sets the duration of the action
		#
		def set_duration( duration )
			@action_progression = 0
			@action_duration = duration
		end
		
		##
		# Gets the action progress
		#
		def progress
			@action_progression += 1.to_f / @action_duration
			return !busy?
		end
		
		##
		#
		#
		def kill
			@action_progression = 1
			@action_killed = true
		end
		
		##
		#
		#
		def killed?
			@action_killed
		end
	
		##
		#
		#
		def busy?
			@action_progression < 1
		end
		
		##
		# Gets the current progress duration
		#
		def progress_duration
			return @action_progression * @action_duration
		end
		
		##
		# Clears the queue
		#
		def clear_queue
			@actions = []
		end
		
		##
		# Returns the position of the ship
		#
		def position
			@location.identifier
		end
		
		##
		# Gets the location
		#
		def location
			@location
		end
		
		##
		#
		#
		def report
			@action_result
		end
		
		##
		#
		#
		def report=( value )
			@action_result = value
		end
		
		##
		# Leaves the current position
		#
		def leave
			@location.leave ship if @location
		end
		
		##
		# Travels to a location
		#
		def travel( node )
			@location = node
		end
		
		##
		# Enters the location
		#
		def join
			@location.join ship if @location
		end
	end
end