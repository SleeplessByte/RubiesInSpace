require_relative 'event'

module Space
	
	module Event
	
		class AttackIncoming < Event
			
			attr_reader :timestamp, :source, :damage
			
			def initialize( timestamp, source, damage )
				@timestamp = timestamp
				@source = source
				@damage = damage
			end
			
		end
	end
	
end