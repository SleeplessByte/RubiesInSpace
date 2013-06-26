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
		"#{ scan.source }. I was gazing through my scanner when I looked upon the surroundings. #{ scan.environment[ :log ] } In the distance I could see #{ scan.paths.length } bodies, but they were too far to make out. #{ scan.friendlies.length - 1 } other ships of the Alliance were enjoying the view, but not for much longer as from the horizon #{ scan.enemies.length } unknown ships were closing in..."
	end
	
end