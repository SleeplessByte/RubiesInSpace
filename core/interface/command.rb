require_relative 'iship'

class Ship

	class Interface

		##
		# A command is created when the crew invokes the ship interface
		#
		class Command
			
			attr_reader :source
			
			##
			# Initializes the command
			#
			def initialize( source )
				@source = source
			end
			
		end
		
	end

end