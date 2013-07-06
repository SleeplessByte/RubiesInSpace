require_relative 'command'

class Ship

	class Interface

		class TransferCommand < Command

			attr_reader :destination, :amount
			
			def intialize( source, destination, amount )
				
				super source
				@destination = destination
				@amount = amount
				
			end
			
		end
	end
	
end