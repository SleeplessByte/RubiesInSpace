
class RubiesInSpaceRunner
	
	class Instance
		attr_accessor :step, :players, :universe
		attr_reader :state
		
		def initialize
			@step = 0
			@state = nil
			@players = []
		end
		
		def running?
			@state === :running
		end
		
		def aborted?
			@state === :aborted
		end
		
		def paused?
			@state === :paused
		end
		
		def created?
			@state === :created
		end
		
		def active?
			paused? or running?
		end
		
		def create
			@state = :created
		end
		
		def abort
			@state = :aborted
		end
		
		def run
			if created?
				@state = :running
				@step = 0
				return true
			end
			return false
		end
		
		def pause
			if running?
				@state = :paused
				return true
			end
			return false
		end
		
		def resume
			if paused?
				@state = :running
				return true
			end
			return false
		end
		
		def snapshot
			snapshot = self.clone
			snapshot.players = self.players.map { |player| player.snapshot }
			return snapshot
		end
	end
	
end