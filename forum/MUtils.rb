helpers do
	def CreatNode(name,texts)
		if Node.where(name:name).exists?
			@msg = '{"msg", "exists" }' #exist => 0
		else
			Node.create(
				name: name,
				texts: texts
				)
			@msg = '{"msg", true }'
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
	def CreatPostHash(title = "" ,texts = "",user = "" ,node = "",mother = "")
		@hash = Digest::SHA1.hexdigest("the post #{title}#{texts} to #{node} by #{user} when #{Time.now} form #{mother} #{rand(9999).to_s}")
		return @hash
	end
	def PostToMongo(ititle,itexts,iuser,inode,itype,istatus,imother)
		@hash = CreatPostHash(ititle,itexts,iuser,inode,imother)
		if Post.create!(
			posthash: @hash,
			title: ititle,
			texts: itexts,
			user: iuser,
			time: Time.now(),
			node: inode,
			type: itype,
			status: istatus, 
			mother: imother
			)
			$post_cache.update
			@a = Hash["hasH", @hash.to_s, "status",1]
		else
			@a = Hash["hasH" , '',"status",0]
		end
		return @a.to_json
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
			@ck = Hash["name",iname,"mail",Digest::MD5.hexdigest(User.where(name: iname,pass:ipass)[0].mail)
]
			@ck_json = @ck.to_json
			cookies[:auth] = AES.encrypt(@ck_json , ikey)
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
		@count_topic = Post.where(type: 'topic').count
		@count_all = (Post.count) - @count_topic
		@plus = 0
		if @count_topic%max > 0
			@plus = 1
		end
		@page_topic = @count_topic/max + @plus
		return [@count_all,@count_topic,@page_topic]
	end
	def GetLatestPost(max,page)
		@num=0-(max*page)
		@opt = $post_cache.getcachedlist()
		@data_opt = @opt[max*(page-1),max]
		return @data_opt
	end
	def GetLatestPostByNode(node,max,page)
		@num = 0-(max*page)
		@opt = $post_cache.getcachedlist(node)
		@data_opt = @opt[max*(page-1),max]
		return @data_opt
	end
	def CheckCookie()
		if cookies[:auth] == nil
			cookies[:auth] = ''
		end
	end
	def Logined?()
		@msg = true
		if cookies[:auth] == nil
			@msg = false
		end
		if cookies[:auth] == ""
			@msg = false
		end
		return @msg
	end
end
