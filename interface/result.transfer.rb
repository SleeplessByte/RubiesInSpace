class TransferResult
	
	attr_reader :source, :destination, :amount, :transferred
	
	def intialize( source, destination, amount, transferred )
	
		@transferred = transferred
		@amount = amount
		@source = source
		@destination = destination
		
	end
	
	def efficiency
		@transferred / @amount.to_f
	end
	
end