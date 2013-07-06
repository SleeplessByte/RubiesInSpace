require_relative 'report'

class Ship

	class Interface

		class CollectReport < CommandReport
		
			attr_accessor :collected
			
			def initialize( timestamp, source, collected )
				super timestamp, source
				@collected = collected
			end
			
		end
	end
	
end