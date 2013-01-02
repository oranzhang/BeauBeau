# -*- coding:utf-8 -*-
require 'mongoid'
Mongoid.load!(settings.config_dir + "/mongoid.yml")
class Topic
	include Mongoid::Document
#	include Kaminari::MongoidExtension::Document
	store_in collection: "topics"
	field :title, type: String
	field :texts, type: String
	field :time, type: Time
	field :user, type: String
	field :tags, type: Array
	field :status, type: String
	field :last_reply_time, type: Time
	validates_presence_of :title ,:texts ,:user ,:time
end
class Reply
	include Mongoid::Document
#	include Kaminari::MongoidExtension::Document
	store_in collection: "replies"
	field :texts, type: String
	field :time, type: Time
	field :user, type: String
	field :belong_to, type: String
	shard_key :name, :texts
	validates_presence_of :texts ,:user ,:belong_to ,:time
end
class Tag
	include Mongoid::Document
	store_in collection: "tags"
	field :name, type: String
	field :link_to, type: String
	shard_key :name, :texts
	validates_presence_of :name
end
class Setting
	include Mongoid::Document
	store_in collection: "settings"
	field :title, type: String
	field :data
	validates_presence_of :title
	validates_uniqueness_of :title
end
