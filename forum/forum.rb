require 'sinatra/base'
require "sinatra/cookies"
require 'digest/sha1'
require 'digest/md5'
require "markdown"
require 'mongoid'
require 'json'
require 'aes'
require './MUtils'


class Mforum < Sinatra::Base
	config_file = "#{File.dirname(__FILE__)}/config/config.json"
 	set :views, settings.root + '/ui'
 	set :public_folder, File.dirname(__FILE__) + '/ui/assets'
 	conf = JSON.parse(File.new(config_file,"r").readlines[0])
 	aes_key = conf["cookies_key"]
	Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
	Mongoid.logger = Logger.new($stdout)
	Moped.logger = Logger.new($stdout)


	helpers MUtils, Sinatra::Cookies




	get "/" do
		@name = conf["sitename"]
		@title = conf["sitetitle"]
		erb :index
	end
	get "/!!/GetIndexData" do
		@at_data = GetLatestPost(conf["maxitemnumber"],1)
		@data = JSON.parse(GetLatestPost(conf["maxitemnumber"],1))
		erb :topicbox
	end
	get "/!!/Posting/^:node" do
		if Node.where(name: param[:node].to_s).exists?
			@node_exists = true
			@node = param[:node].to_s
		else
			@node_exists = false
		end
		erb :topicbox
	end
	get "/!!/Userbox" do
		@x = cookies[:auth]
		while @x ==  nil do
			@x = ""
		end
		if cookies[:auth] == nil
			@msg = 0 # 0 => not logined
		else
			@a = AES.decrypt(@x,aes_key)
			@info = JSON.parse(@a)
			@msg = 1 # 1 => already logined
		end
		erb :userbox
	end
	get "/!!/CTbox/:node" do
		@node_exists = false
		if Node.where(name:param[:node]).exists?
			@node_exists = true
		end
		erb :CTbox
	end
	get "/!!/Clean" do
		""
	end

end
