require_relative 'command'

class Ship

	class Interface

		class TravelCommand < Command

			attr_reader :node
			
			def initialize( source, node )
				super source
				@node = node
			end
			
		end

	end
	
end