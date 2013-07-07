require_relative 'command'

class Ship

	class Interface

		class CommunicateCommand < Command

			attr_reader :data
			
			def initialize( source, data )
				super source
				@data = data
			end
			
		end
	end

end