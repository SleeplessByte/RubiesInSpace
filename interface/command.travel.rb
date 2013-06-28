require_relative 'command'

class ShipInterface

	class TravelCommand < Command

		attr_reader :node
		
		def initialize( source, node )
			super source
			@node = node
		end
		
	end

end