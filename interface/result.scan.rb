class ScanResult
	
	attr_reader :source, :environment, :paths, :friendlies, :enemies
	
	def initialize( source, environment, paths, friendlies, enemies )
		@source = source
		@environment = environment
		@paths = paths
		@friendlies = friendlies
		@enemies = enemies
	end
	
end