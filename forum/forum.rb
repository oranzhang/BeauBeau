require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/config_file"
require "sinatra/authorization"
require 'digest/sha1'
require "markdown"
require 'mongoid'
require 'json'
#App start
class Mforum < Sinatra::Base
	set :authorization_realm, "Protected zone"
	helpers Sinatra::Cookies
	register Sinatra::ConfigFile
 	config_file "#{File.dirname(__FILE__)}/../config/config.yml"
 	set :views, settings.root + '/../ui'
 	set :public_folder, File.dirname(__FILE__) + '/../ui/assets'
	#Load Mongodb
	Mongoid.load!("#{File.dirname(__FILE__)}/../config/mongoid.yml")
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
	helpers do
		def CreatNode(name,texts)
			if Node.where(name:name).exists?
				return 0 #exist => 0
			else
				Node.create(
					name: name,
					texts: texts
					)
				return 1
		end
	end
		def GetPostData(posthash)
			if Post.where(hash = posthash).exists?
				return Post.find_by(hash: posthash)
			else
				return 0 # 0 -> Not Exists
			end

		end
		def CreatPostHash(title = "" ,texts = "",user = "" )
			hash = Digest::SHA1.hexdigest("the post #{title}#{texts} by #{user} when #{Time.now} form #{imother}")
			return hash
		end
		def PostToMongo(ititle,itexts,iuser,inode,itype,istatus,imother)
			@hash = CreatPostHash(ititle,itexts,iuser,imother)
			Post.create!(
				hash: @hash,
				title: ititle,
				texts: itexts,
				user: iuser,
				time: Time.now(),
				node: inode,
				type: itype,
				status: istatus, 
				mother: imother
			)
		end
		def CreatUser(iname,ipass,imail)
			if User.where(name: iname).exists?
				msg = 1 #
			else if User.where(mail:imail).exists?
				msg = 2 #Email exists => msg = 2
				else User.create(
					name: iname,
					pass: ipass,
					mail: imail,
					regtime: Time.now(),
					status: "user",
					more: ""
					) 
				msg = 0 #Su => 0
			end
			return msg
		end
		def Login(iname,ipass)
			if User.where(name: iname,pass:ipass).exists?
				authorize(iname,ipass)
				return 1 #succ
			else
				return 0 #incorrent
			end
		end
		def ResetPass(imail,q,a,pass)
			if User.where(mail: imail,q: q,a: a).exists?
				User.where(mail: imail,q: q,a: a).update(pass: pass)
				return 0 #su
			else
				return 1 #err
			end
		end
		def GetPostListInfo(max)
			count_all = Post.count
			count_topic = Post.where(type: 'topic').count
			plus = 0
			if count_topic%max > 0
				plus = 1
			end
			page_topic = count_topic/max + plus
			return [count_all,count_topic,page_topic].to_json
		end
		def GetNewestPost(max,page)
			data = Array.new
			for x in 1..10 do
				num=0-(max*(page-1)+x)
				data << Post.where(mother: 'self').sort(_id: num).limit(-1)
			end
			return data.to_json
			
		end
		def GetNewestPostByNode(node,max,page)
			data = Array.new
			for x in 1..10 do
				num=0-(max*(page-1)+x)
				data << Post.where(node: node,mother: 'self').sort(_id: num).limit(-1)
			end
			return data.to_json
		end
		def GetReplyByTopic(topichash)
			data = Array.new
			for x in 1..10 do
				num=0-(max*(page-1)+x)
				data << Post.where(nade: node ,mother: topichash).sort(_id: num).limit(-1)
			end
			return data.to_json
		end
	end

	get "/" do
		erb :index
	end

	run! if app_file == $0
end
end
