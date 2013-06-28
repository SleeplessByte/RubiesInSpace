require_relative 'command'

class ShipInterface

	class TransferCommand < Command

		attr_reader :destination, :amount
		
		def intialize( source, destination, amount )
			
			super source
			@destination = destination
			@amount = amount
			
		end
		
	end
end