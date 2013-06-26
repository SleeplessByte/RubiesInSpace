
##
# Originated from lc: language confluxer (http://www.ruf.rice.edu/~pound/revised-lc)
# - Written by Christopher Pound (pound@rice.edu), July 1993.
# - Loren Miller suggested I make sure lc starts by picking a letter pair that was at the beginning of a data word, Oct 95.
# - Cleaned it up a little bit, March 95; more, September 01
# - Ruby, options, June 2013 by Derk-Jan Karrenbeld
#
# The datafile should be a bunch of words from some language with minimal punctuation or 
# garbage (# starts a comment!). Try mixing and matching words from different languages to 
# get just the balance you like. The output offcourse needs some editing.
class Confluxer
    
	@@cache = {}
	
	MAX_LENGTH = 12
	MIN_LENGTH = 3
	
	##
	#
	#
	def self.run( filename, number, randomizer = Random, options = {} )
		
		@@randomizer = randomizer
		
		if options[ :override ] or !@@cache[ filename ]
			@@cache[ filename ] = Confluxer::Data.new filename
		end
		data = @@cache[ filename ]
		
		max_length = options[ :max ] || MAX_LENGTH
		min_length = options[ :min ] || MIN_LENGTH
		capitalize = options[ :capitalize ] || true
		
		##
		# Loop to generate new words, beginning with a start_pair; find a word,
		# then continue to the next word using the last two characters (the last
		# of which will be whitespace) from the previous word as a "seed" for the new;
		# oh, and only print the first max_length characters of any words
		
		word = data.fetch_start
		number.times do
			key = word[ -2..-1 ].downcase
			key.capitalize! if capitalize
			word = fetch( key, data, min_length, capitalize )
			yield word[ 0...max_length ]
		end
	end
	
	##
	# Messy recursive function to build a word, handling "seeds" 
	# from previous words properly
	#
	def self.fetch( word, data, min_length, capitalize )
		key = word[ -2..-1 ]
		letter = data.fetch key
		if /\s/.match( word )
			if word.length <= min_length
				key = ( key[ -1 ] + letter ).downcase
				key.capitalize! if capitalize
				if data.fetch key == ' '
					key = data.fetch_start
				end
				return fetch( key, data, min_length, capitalize )
			end
			return word[ 0...-1 ]
		end
		return fetch( word + letter, data, min_length, capitalize )
	end
	
	def self.rand( n )
		@@randomizer.rand n
	end	
	
	##
	#
	#
	class Data
		
		def initialize( filename )
			@contents = {}
			@starters = []
			
			File.open( filename, "r" ) do | infile |
				@data = ""
				while ( line = infile.gets )
					next if line[ 0 ] == '#'
					@data += line.gsub( /\n/, '' ).gsub( /\r/, '' )
				end
			end
			
			@starters.push @data[ 0..1 ]
			
			while @data.length > 2
				triplet = @data[ 0..2 ]
				if !@contents[ triplet[ 0..1 ] ]
					@contents[ triplet[ 0..1 ] ] = []
				end
				@contents[ triplet[ 0..1 ] ].push triplet[ -1 ]
				@starters.push triplet[ -2..-1 ] if triplet[ 0 ] == ' '
				@data = @data[ 1..-1 ]
			end

		end
		
		##
		#
		#
		def fetch_start( )
			return @starters[ Confluxer.rand @starters.length ]
		end
		
		##
		#
		#
		def fetch( key )
			return ' ' if !@contents[ key ]
			return @contents[ key ][ Confluxer.rand @contents[ key ].length ]
		end
		
	end
end

Confluxer.run( 'Celtic.txt', 100, Random.new, { :min => 3, :capitalize => false } ) { |r| puts r }