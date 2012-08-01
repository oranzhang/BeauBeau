require 'sinatra/base'
require "sinatra/cookies"
require 'digest/sha1'
require 'digest/md5'
require "markdown"
require 'mongoid'
require 'json'
require 'aes'


class Mforum < Sinatra::Base
	config_file = "#{File.dirname(__FILE__)}/config/config.json"
 	set :views, settings.root + '/ui'
 	set :public_folder, File.dirname(__FILE__) + '/ui/assets'
 	conf = JSON.parse(File.new(config_file,"r").readlines[0])
 	aes_key = conf["cookies_key"]
	Mongoid.load!("#{File.dirname(__FILE__)}/config/mongoid.yml")
	Mongoid.logger = Logger.new($stdout)
	Moped.logger = Logger.new($stdout)
	helpers do
		def CreatNode(name,texts)
			if Node.where(name:name).exists?
				@msg = 0 #exist => 0
			else
				Node.create(
					name: name,
					texts: texts
					)
				@msg = 1
			end
			return @msg
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
			else 
				User.create(
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
				ck_json = '{"name" : ' + "#{iname} , " + '"mail : "' + "#{Digest::SHA1.hexdigest(User.where(name: iname,pass:ipass).mail)}"
				cookies[:auth] = AES.encrypt(ck_json , aes_key)
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
		def GetLatestPost(max,page)
			data = Array.new
			for x in 1..10 do
				num=0-(max*(page-1)+x)
				data << Post.where(mother: 'self').sort(_id: num).limit(-1)
			end
			return data.to_json
		end
		def GetLatestPostByNode(node,max,page)
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

	#helpers Sinatra::Cookies




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
end