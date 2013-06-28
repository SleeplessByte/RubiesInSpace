require_relative 'iship.icomponent'
require_relative 'command.attack'
require_relative 'command.build'
require_relative 'command.research'
require_relative 'command.travel'
require_relative 'command.transfer'
require_relative 'command.communicate'
require_relative 'command.collect'
require_relative 'command.scan'

#
#
class ShipInterface
	
	#
	#
	class CommandCenter < ComponentInterface
		
		##
		# Queue action
		#
		def queue( command )
			unless command.is_a? Command
				raise TypeError.new "That's not a command the computer will understand"
			end
			
			@component.queue command
		end
		
		##
		# Empty action queue
		#
		def clear_queue
			@component.clear_queue
		end
		
		##
		# Current action
		#
		def current_command
			@component.current
		end
		
		##
		# Get next action
		#
		def next_command
			@component.next
		end
		
		##
		# Get action result
		#
		def report
			return nil if @ship.busy?
			return @component.report
		end
		
		##
		# Create travel action to node
		#
		def travel_command( node )
			ShipInterface::TravelCommand.new @interface, node
		end
		
		##
		# Create collect action for time
		#
		def collect_command( duration )
			ShipInterface::CollectCommand.new @interface, duration
		end
		
		##
		# Create transfer action of amount to ship
		#
		def transfer_command( amount, ship )
			ShipInterface::TransferCommand.new @interface, amount, ship
		end
		
		##
		# Create scan action
		#
		def scan_command()
			ShipInterface::ScanCommand.new @interface
		end
		
		##
		# Create build action of item
		#
		def build_command( item )
			ShipInterface::BuildCommand.new @interface, item
		end
		
		##
		# Create research action of item
		#
		def research_command( item )
			ShipInterface::ResearchCommand.new @interface, item
		end
		
		##
		# Create communicate action of data
		#
		def communicate_command( *data )
			ShipInterface::CommunicateCommand.new @interface, data
		end
		
		##
		# Create attack action of data
		#
		def attack_command( ship )
			ShipInterface::AttackCommand.new @interface, ship
		end
		
	end
	
end