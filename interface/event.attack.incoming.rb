module SpaceEvent
	class AttackIncoming
		
		attr_reader :timestamp, :source, :damage
		
		def initialize( timestamp, source, damage )
			@timestamp = timestamp
			@source = source
			@damage = damage
		end
		
	end
end