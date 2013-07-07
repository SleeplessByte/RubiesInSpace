require_relative 'report'

class Ship

	class Interface

		class ScanReport < CommandReport
		
			attr_reader :environment, :paths, :friendlies, :enemies
			
			def initialize( timestamp, source, environment, paths, friendlies, enemies )
				super timestamp, source
				@environment = environment
				@paths = paths
				@friendlies = friendlies
				@enemies = enemies
				finalize
			end
			
		end
		
	end
	
end