require 'sinatra'
require 'sinatra/support'

require_relative 'helpers'
require_relative 'core/runner'

configure do
	set :public_folder, Proc.new { File.join( root, "static" ) }
	enable :sessions
end

###
# The online version will handle multiple running instances
# The offline version won't, so we define this globally for now
$runner = RubiesInSpaceRunner.new

before do
	@snapshot = $runner.instance.snapshot
	session[ :state ] = @snapshot.state
end

#=====-=====-=====-=====-=====-=====# 
# Home
#=====-=====-=====-=====-=====-=====#
get '/' do
	erb :index
end

#=====-=====-=====-=====-=====-=====# 
# Simulation
#=====-=====-=====-=====-=====-=====#
get '/simulation' do
	erb :'simulation/index'
end

post '/simulation' do
	try_setting_simulation( params )
	redirect to '/simulation'
end

#=====-=====-=====-=====-=====-=====# 
# PLAYERS
#=====-=====-=====-=====-=====-=====#
get '/player/:id' do
	@player = $runner.players.find do |p| p.id.to_s == params[:id] end
	if @player.nil?
		redirect to '/players'
	else
		erb :'players/show'
	end
end

get '/players/join' do
	erb :'players/join'
end

get '/players' do
	erb :'players/index'
end

post '/players' do
	unless try_adding_player( params )
		redirect to session[ :previous_url ] || '/players/join'
	else
		redirect to '/players'
	end
end

get '/crews' do
	erb :'players/crews'
end