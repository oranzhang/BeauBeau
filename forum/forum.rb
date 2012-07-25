require 'sinatra/base'
require "sinatra/cookies"
require "sinatra/config_file"
require "sinatra/authorization"
require 'digest/sha1'
require "markdown"
require 'mongoid'
#App start
class Mforum < Sinatra::Base
	set :authorization_realm, "Protected zone"
	helpers Sinatra::Cookies
	register Sinatra::ConfigFile
 	config_file './../config/config.yml'
	#Load Mongodb
	Mongoid.load!("./../config/mongoid.yml")
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
			shard_key :hash, :title, :texts, :user, :time, :node, :type, :status
		end
	helpers do

		def GetPostData(posthash)
			if Post.where(hash=posthash).exists?
				return Post.find_by(hash: posthash)
			else
				return 0 # 0 -> Not Exists
			end

		end
		def CreatPostHash(title = "" ,texts = "",user = "" )
			hash = Digest::SHA1.hexdigest("thepost #{title}#{texts} by #{user} when #{Time.now}")
			return hash
		end
		def PostToMongo(ititle,itexts,iuser,inode,itype,istatus)
			@hash = CreatPostHash(ititle,itexts,iuser)
			Post.create!(
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
				return msg
			end
		end
		def Login(iname,ipass)
			if User.where(name: iname,pass:ipass).exist?
				authorize(iname,ipass)
				return 1 #succ
			else
				return 0 #incorrent
			end
		end
		def ResetPass(imail,q,a,pass)
			if User.where(mail: imail,q: q,a: a).exist?
				User.where(mail: imail,q: q,a: a).update(pass: pass)
				return 0 #su
			else
				return 1 #err
			end
		end
		def GetNewestPost(max,page)
			Post.each
		end
		def GetNewestPostByNode(node,max,page)
		end
		def GetReplyHashByTopic(topichash)
		end


	end

	get "/" do
		"There are nodes <br>"
		Node.each do |nodes|
			"#{nodes.name}"
		end
	end

	get '/creatnode/:name/:texts' do
		if Node.where(name:params[:name]).exist?
			return 0 #exist => 0
		else
			Node.create(
				name: params[:name],
				texts: params[:texts]
				)
		end
	end

	get "/?/test" do
		CreatUser("a","123","x")
		PostToMongo("dfsd","fsd","dsfwe","fwe","fwe","wqe")
		CreatUser("ads","1sdas23","xsd")
		PostToMongo("dfsfghd","fsfghd","dshfgfwe","ffwe","fwfe","wfqe")
		CreatUser("adas","123","xdas")
		PostToMongo("dfwqwesd","fseqwd","dsfwewe","fqwewe","fwxcve","wqxcve")





run! if app_file == $0
end
