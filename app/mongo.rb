# -*- coding:utf-8 -*-
Mongoid.load!(settings.config_dir + "/mongoid.yml")
#class MongoidUser 
#	include Mongoid::Document
#	store_in collection: "users"
#	field :name, type: String
#	field :pass, type: String
#	field :mail, type: String
#	field :regtime, type: Time
#	field :status # "user" , "admin" , "ban"
#	field :more
#	index({ regtime: 1 }, { unique: true, name: "regtime_index" })
#end
class Topic
	include Mongoid::Document
	store_in collection: "topics"
	field :title, type: String
	field :texts, type: String
	field :time, type: Time
	field :user, type: String
	field :last_reply_time, type: Time
end
class Reply
	include Mongoid::Document
	store_in collection: "replies"
	field :texts, type: String
	field :time, type: Time
	field :user, type: String
	field :blong_to, type: String
	shard_key :name, :texts
end
class Tag
	include Mongoid::Document
	store_in collection: "tags"
	field :name, type: String
	field :link_to, type: String
	field :status, type: String
	field :end_time, type: Time
	field :plan,type: String
	shard_key :name, :texts
end
