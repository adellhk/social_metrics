require "sinatra"
require "instagram"
require 'httparty'
require "byebug"

enable :sessions

CALLBACK_URL = "http://localhost:4567/oauth/callback"

Instagram.configure do |config|
  config.client_id = "668c24e10ec64dca9acc1353861ad072"
  config.client_secret = "43cdfa54b7c046e1a80bad4aecf27ce7"
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

get "/" do
	erb :index
end

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/"
end

post "/user_search" do
  client = Instagram.client(:access_token => session[:access_token])
  # byebug
  # response = client.user_search(params["name"])
  # @users = client.user_search(params["name"])
  	html = "<h1>Search for users on instagram, by name or usernames</h1>"
  for user in client.user_search(params["name"])
     follows = HTTParty.get("https://api.instagram.com/v1/users/#{user.id}/follows?access_token=#{session["access_token"]}")
     # byebug
     html << "<li> <img src='#{user.profile_picture}'> #{user.username} #{user.full_name}</li>"
     # html << "<li> <img src='#{user.profile_picture}'> #{user.username} #{user.full_name} #{follows.count}</li>"
  end
	# redirect '/user_search'
	html
end

def get_followers_count(user_id, next_cursor=nil)
	followers_count = 0

	if next_cursor
		response = HTTParty.get("https://api.instagram.com/v1/users/#{user.id}/follows?access_token=#{session["access_token"]}&#{next_cursor}")
	else
		response = HTTParty.get("https://api.instagram.com/v1/users/#{user.id}/follows?access_token=#{session["access_token"]}")
	end

	until response['pagination'].empty?
		next_cursor = response['pagination']['next_cursor']
		get_followers_count(user_id, next_cursor)
		followers_count += response['data'].count
	end
end

get 'user_search' do

	erb :user_search
end