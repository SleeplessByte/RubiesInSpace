class ScanResult
	
	attr_reader :source, :environment, :paths, :friendlies, :enemies, :timestamp
	
	def initialize( timestamp, source, environment, paths, friendlies, enemies )
		@timestamp = timestamp
		@source = source
		@environment = environment
		@paths = paths
		@friendlies = friendlies
		@enemies = enemies
		@log = SpaceLog.generate( :result, :scan, self )
	end
	
	def to_s
		@log
	end
	
end

ScanResult.freeze