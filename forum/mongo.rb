Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
Mongoid.logger = Logger.new($stdout)
Moped.logger = Logger.new($stdout)
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
	field :posthash, type: String
	field :title, type: String
	field :texts, type: String
	field :user, type: String
	field :time, type: Time
	field :node, type: String
	field :type # "topic" &"reply" 
	field :status # 0 -> basic , 1 -> important , 2 -> HEXIE
	field :mother
	shard_key :hash, :title, :texts, :user, :time, :node, :type, :status, :mother
	index({ time: 1 }, { unique: true, name: "time_index" })
end
