require_relative 'command'

class ShipInterface

	class AttackCommand < Command
		
		attr_reader :destination
		
		##
		#
		#
		def initialize( source, destination )
			super source
			@destination = destination
		end
		
	end
	
end