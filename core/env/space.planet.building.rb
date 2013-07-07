require_relative 'space.planet'

module Space

	class Planet

		#
		#
		class Building
			
			attr_reader :planet
			
			#
			#
			def initialize( planet )
				@planet = planet
			end
			
		end
		
	end
	
end