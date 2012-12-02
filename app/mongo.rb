class User 
	include Mongoid::Document
	store_in collection: "users"
	field :name, type: String
	field :pass, type: String
	field :mail, type: String
	field :regtime, type: Time
	field :status # "user" , "admin" , "ban"
	field :q
	field :a
	shard_key :name, :pass, :mail, :regtime, :status, :q, :a
	index({ regtime: 1 }, { unique: true, name: "regtime_index" })
end
class Topics
	include Mongoid::Document
	store_in collection: "plans"
	field :name, type: String
	field :hash, type: String
	field :time, type: Time
	field :limted, type: String
	field :server, type: String
class Replies
	include Mongoid::Document
	store_in collection: "hosts"
	field :name, type: String
	field :texts, type: String
	field :start_time, type: Time
	field :end_time, type: Time
	field :plan,type: String
	shard_key :name, :texts
end
class Tags
	include Mongoid::Document
	store_in collection: "hosts"
	field :name, type: String
	field :texts, type: String
	field :start_time, type: Time
	field :end_time, type: Time
	field :plan,type: String
	shard_key :name, :texts
end
