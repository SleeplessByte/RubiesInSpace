require_relative 'iship'

class ShipInterface
	
	class CommandReport
		
		attr_reader :timestamp, :source
		def initialize( timestamp, source )
			@source = source
			@timestamp = timestamp
			@log = "Report #{ self.object_id } : #{ self.class.name } is not finalized"
		end
		
		##
		#
		#
		def finalize
			return @log if self.frozen?
			
			myself = self.class.name.downcase.gsub( 'report', '' ).split( ':' ).last
			@log = SpaceLog.generate( :result, myself, self )
			self.freeze
			
			return @log
		end
		
		##
		#
		#
		def to_s
			@log
		end
	
	end
	
end