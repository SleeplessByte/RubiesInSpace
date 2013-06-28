class SpaceLog 
	
	def self.generate( type, subject, *args )

		method = "generate_#{type}_of_#{subject}"
		if respond_to? method
			send( method, *args )
		end
		
	end
	
	def self.generate_scan_of_planet( environment, tech )
		"I saw an amazing planet."
		
		# TODO inc. env and tech
	end
	
		
	def self.generate_scan_of_star( environment, tech )
		"I looked upon an impressive star."
	end
	
	def self.generate_scan_of_asteroid( environment, tech )
		"I could only see a clump of rock."
	end
	
	def self.generate_result_of_scan( scan )
		#tech = scan.source.tech
		
		# TODO use werd to generate nice logs, use tech
		result = "#{ scan.source }. I was gazing through my scanner when I looked upon the surroundings. #{ scan.environment[ :log ] } In the distance I could see #{ scan.paths.length } bodies, but they were too far to make out. " 
		
		result += "#{ scan.friendlies.length - 1 } other ships of the Alliance were enjoying the view. " if scan.friendlies.length > 1
		
		result += "We can't stay much longer as from the horizon I spotted #{ scan.enemies.length } unknown ships closing in..." if scan.enemies.length > 0
		
		return result
	end
	
	def self.generate_result_of_travel( travel )
		
		"#{ travel.source }. Pff #{ travel.distance } lightyears! That took us long enough. More than #{ travel.duration.floor } days flying. We consumed #{ travel.depletion.round } litres of deuterium. But we are finally at #{ travel.node }!"
		
	end
	
	def self.generate_result_of_collect( collect )
		
		"#{ collect.source }. We've managed to collect #{ collect.collected.floor } litres of deuterium."
		
	end
	
	def self.generate_result_of_attack( attack )
		"#{ attack.source }. BAM BAM ABM #{ attack.damage } damage inflicted on #{ attack.destination } and it only depleted us #{ attack.depletion } litres of deuterium."
	end
	
end