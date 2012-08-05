require 'sinatra'
require "sinatra/cookies"
require 'digest/sha1'
require 'digest/md5'
require "markdown"
require 'mongoid'
require 'json'
require 'aes'

config_file = "#{File.dirname(__FILE__)}/config/config.json"
set :views, settings.root + '/ui'
set :public_folder, File.dirname(__FILE__) + '/ui/assets'
conf = JSON.parse(File.new(config_file,"r").readlines[0])
aes_key = conf["cookies_key"]
Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
Mongoid.logger = Logger.new($stdout)
Moped.logger = Logger.new($stdout)
require './MUtils'
		class User 
			include Mongoid::Document
			store_in collection: "users"
			field :name, type: String
			field :pass, type: String
			field :mail, type: String
			field :regtime, type: Time
			field :status # "user" , "admin" , "ban"
			field :more, type: String
			field :q
			field :a
			shard_key :name, :pass, :mail, :regtime, :status, :more, :q, :a
			index({ regtime: 1 }, { unique: true, name: "regtime_index" })
		end
		class Node 
			include Mongoid::Document
			store_in collection: "nodes"
			field :name, type: String
			field :texts, type: String
			shard_key :name, :texts
		end
		class Post 
			include Mongoid::Document
			store_in collection: "posts"
			field :hash, type: String
			field :title, type: String
			field :texts, type: String
			field :user, type: String
			field :time, type: Time
			field :node, type: String
			field :type # "topic" &"reply" 
			field :status # 0 -> basic , 1 -> important , 2 -> HEXIE
			field :mother
			shard_key :hash, :title, :texts, :user, :time, :node, :type, :status, :mother
		end
get "/" do
	@name = conf["sitename"]
	@title = conf["sitetitle"]
	erb :index
end
get "/!!/GetIndexData" do
	@u = User.new
	@p = Post.new
	@count = GetPostListInfo(conf["maxitemnumber"])
	@data = GetLatestPost(conf["maxitemnumber"],1)
	erb :topicbox
end
get "/!!/Posting/^:node" do
	if Node.where(name: params[:node].to_s).exists?
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
	@node = params[:node]
	@node_exists = false
	if Node.where(name: @node).exists?
		@node_exists = true
	end
		erb :CTbox
end
get "/!!/LRbox" do
	@cookies = cookies[:auth]
	erb :LRbox
end
get "/!!/Clean" do
	""
end