module SpaceEvent
	class AttackOutgoing
		
		attr_reader :timestamp, :target, :damage, :depletion
		
		def initialize( timestamp, target, damage, depletion )
			@timestamp = timestamp
			@target = target
			@damage = damage
			@depletion = depletion
		end
		
	end
end