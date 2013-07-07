require_relative 'report'

class Ship

	class Interface

		class TransferReport < CommandReport
		
			attr_reader :destination, :amount, :transferred
			
			def intialize( timestamp, source, destination, amount, transferred )
				super timestamp, source
				
				@transferred = transferred
				@amount = amount
				@source = source
				@destination = destination
				
			end
			
			def efficiency
				@transferred / @amount.to_f
			end
			
		end
		
	end
	
end