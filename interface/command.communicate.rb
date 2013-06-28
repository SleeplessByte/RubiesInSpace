require_relative 'command'

class ShipInterface

	class CommunicateCommand < Command

		attr_reader :data
		
		def initialize( source, data )
			super source
			@data = data
		end
		
	end
end