require_relative 'event'

module Space

	module Event
		
		class AttackOutgoing < Event
			
			attr_reader :timestamp, :target, :damage, :depletion
			
			def initialize( timestamp, target, damage, depletion )
				@timestamp = timestamp
				@target = target
				@damage = damage
				@depletion = depletion
			end
			
		end
	end
	
end