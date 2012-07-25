require 'sinatra/base'
require 'digest/sha1'
require 'mongoid'
#App start
class Mforum < Sinatra::Base
	#Load Mongodb
	Mongoid.load!("./config/mongoid.yml")
	Mongoid.logger = Logger.new($stdout)
	Moped.logger = Logger.new($stdout)
		class User 
			include Mongoid::Document
			store_in collection: "users"
			field :name, type: String
			field :pass, type: String
			field :mail, type: String
			field :regtime, type: Time
			field :status, type: String 
			field :more, type: String
			shard_key :name, :pass, :mail, :regtime, :status, :more
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
			field :type, type: String
			field :status, type: String
			shard_key :hash, :title, :texts, :user, :time, :node, :type, :status
		end
	helpers do

		def GetPostData(posthash)
		end
		def CreatPostHash(title = "" ,texts = "",user = "" )
			hash = Digest::SHA1.hexdigest("thepost #{title}#{texts} by #{user} when #{Time.now}")
			return hash
		end
		def PostToMongo(ititle,itexts,iuser,inode,itype,istatus)
			@hash = CreatPostHash(ititle,itexts,iuser)
			Post.create(
				hash: @hash,
				title: ititle,
				texts: itexts,
				user: iuser,
				time: Time.now(),
				node: inode,
				type: itype,
				status: istatus 
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
		end

	end

	get "/" do
		"#{}"
	end

	post ""



run! if app_file == $0
end
