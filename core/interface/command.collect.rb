require_relative 'command'

class Ship

	class Interface

		class CollectCommand < Command

			attr_reader :duration
		
			def initialize( source, duration )
				super source
				@duration = duration
			end
			
		end

	end
	
end