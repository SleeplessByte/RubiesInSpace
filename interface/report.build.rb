require_relative 'report'

class Ship

	class Interface

		class BuildReport < CommandReport
			attr_reader :item
			
			def initialize( source, item )
				super source
				@item = item
			end
			
		end
		
	end
	
end