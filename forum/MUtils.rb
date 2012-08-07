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
			@data = Post.find_by(hash: posthash)
		else
			@data =  0 # 0 -> Not Exists
		end
		return @data
	end
	def CreatPostHash(title = "" ,texts = "",user = "" )
		@hash = Digest::SHA1.hexdigest("the post #{title}#{texts} by #{user} when #{Time.now} form #{imother}")
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
			@msg = '{"msg":1}' #name exists
		end
		if User.where(mail:imail).exists?
			@msg = '{"msg":2}'  #Email exists => msg = 2
		else 
			User.create(
				name: iname,
				pass: ipass,
				mail: imail,
				regtime: Time.now(),
				status: "user",
				more: ""
				) 
			@msg = '{"msg":0}'  #Su => 0
		end
		return @msg
	end
	def Login(iname,ipass,ikey)
		if User.where(name: iname,pass:ipass).exists?
			@ck_json = '{"name" : ' + "#{iname} , " + '"mail : "' + "#{Digest::MD5.hexdigest(User.where(name: iname,pass:ipass)[0].mail)}" + '}'
			cookies[:auth] = AES.encrypt(@ck_json)
			@msg = '{"msg":1}' #succ
		else
			@msg = '{"msg":2}' #incorrent
		end
		return @msg
	end
	def ResetPass(imail,q,a,pass)
		if User.where(mail: imail,q: q,a: a).exists?
			User.where(mail: imail,q: q,a: a).update(pass: pass)
			@msg = 0 #su
		else
			@msg =  1 #err
		end
		return @msg
	end
	def GetPostListInfo(max)
		@count_all = Post.count
		@count_topic = Post.where(type: 'topic').count
		@plus = 0
		if @count_topic%max > 0
			@plus = 1
		end
		@page_topic = @count_topic/max + @plus
		return [@count_all,@count_topic,@page_topic]
	end
	def GetLatestPost(max,page)
		@data = Array.new
		for x in 1..10 do
			@num=0-(max*(page-1)+x)
			if Post.where(mother: 'self').sort(_id: @num).limit(-1) == nil
				@data << Post.where(mother: 'self').sort(_id: @num).limit(-1)
			end
		end
		return @data
	end
	def GetLatestPostByNode(node,max,page)
		@data = Array.new
		for x in 1..10 do
			@num=0-(max*(page-1)+x)
			if Post.where(node: node,mother: 'self').sort(_id: @num).limit(-1) == nil
				@data << Post.where(node: node,mother: 'self').sort(_id: @num).limit(-1)
			end
		end
		return @data
	end
	def GetReplyByTopic(topichash)
		@data = Array.new()
		for x in 1..10 do
			@num=0-(max*(page-1)+x)
			if Post.where(nade: node ,mother: topichash).sort(_id: @num).limit(-1) == nil
				@data << Post.where(nade: node ,mother: topichash).sort(_id: @num).limit(-1)
			end
		end
		return @data
	end
end