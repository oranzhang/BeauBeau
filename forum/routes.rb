get "/" do
	@name = $conf["sitename"]
	@title = $conf["sitetitle"]
	erb :index
end
get "/!!/GetIndexData/page/:page" do
	@count = GetPostListInfo($conf["maxitemnumber"])
	@data = GetLatestPost($conf["maxitemnumber"],params[:page].to_f)
	@pg = (1..@count[2]).map {|x| p x}
	erb :topicbox
end
get "/!!/GetIndexData_js/page/:page" do
	@count = GetPostListInfo($conf["maxitemnumber"])
	@data = GetLatestPost($conf["maxitemnumber"],params[:page].to_f)
	erb :topicbox_js
end
get "/!!/GetNodeData/node/:node/page/:page" do
	@count = GetPostListInfo($conf["maxitemnumber"])
	@data = GetLatestPostByNode(params[:node],$conf["maxitemnumber"],params[:page].to_f)
	@pg = (1..@count[2]).map {|x|}
	erb :topicbox
end
get "/!!/GetNodeData_js/node/:node/page/:page" do
	@count = GetPostListInfo($conf["maxitemnumber"])
	@data = GetLatestPostByNode(params[:node],$conf["maxitemnumber"],params[:page].to_f)
	erb :topicbox_js
end
get "/!!/Posting/^:node" do
	if Node.where(name: params[:node].to_s).exists?
		@node_exists = true
		@node = param[:node].to_s
	else
		@node_exists = false
	end
	erb :topicbox
end
get "/!!/Userbox" do
	CheckCookie()
	@x = ''
	@msg = 0 # 0 => not logined
	unless cookies[:auth] == ""
		@x = cookies[:auth]
		@a = AES.decrypt(@x,$aes_key)
		@info = JSON.parse(@a)
		@msg = 1 # 1 => already logined
	end
	erb :userbox
end

get "/!!/CTbox/:node" do
	@node = params[:node]
	@node_exists = false
	if Node.where(name: @node).exists?
		@node_exists = true
	end
		erb :CTbox
end
get "/!!/LRbox" do
	CheckCookie()
	@cookies = cookies[:auth]
	@my = 0
	unless @cookies == ''
		@ck = JSON.parse(AES.decrypt(@cookies , $aes_key))
		@my = 1
	end
	erb :LRbox
end
get "/!!/LRbox_reg" do
	@reg = 'yes'
	erb :LRbox
end
get "/!!/Login/:name&:pass" do
	@su = Login(params[:name],params[:pass],$aes_key)
	"#{@su}"
end
get "/!!/Register/:b64" do
	@b64 = JSON.parse(Base64.decode64(params[:b64]))
	@msg = CreatUser(@b64["user"],@b64["pass"],@b64["mail"])
	"#{@msg}"
end
get "/!!/CookieClean" do
	cookies[:auth] = ""
	'{ "logout" : true }'
end
get "/!!!!/CreatNode/:name/:texts" do
	@a = CreatNode(params[:name],params[:texts])
	"#{@a}"
end
get "/!!/Clean" do
	""
end
get "/!!/GetNodeList" do
	@node  = Node
	erb :nodelist
end
post '/!!/post/*' do |c|
	@data = JSON.parse(Base64.decode64(c))
	@json = PostToMongo(
		@data["title"],
		@data["data"],
		JSON.parse(AES.decrypt(cookies[:auth] , $aes_key))["name"],
		@data["node"],
		"topic",
		"basic",
		"")
	PostToMongo(
		'init',
		'',
		'',
		@data["node"],
		"reply",
		"basic",
		JSON.parse(@json)["hasH"])
	"#{@json}"
end
post '/!!/viewpost/*' do |hash|
	@data = Post.where(posthash: hash)
	if @data.exists?
		@type = "topic"
	else
		@type = "notfound"
	end
	erb :viewtopic
end
get '/!!/getreplies/*' do |hash|
	@data = Array.new
	@num = Post.where(mother: hash).count
	Post.where(title:"reply",mother: hash).sort(_id: 1).limit(@num).each  do |post|
		if post != nil
			@data << post.posthash
		end
	end
	@type = "reply"
	erb :viewtopic
end
post '/!!/reply/*' do |c|
	@data = JSON.parse(Base64.decode64(c))
	@json = PostToMongo(
		'reply',
		@data["data"],
		JSON.parse(AES.decrypt(cookies[:auth] , $aes_key))["name"],
		Post.where(posthash:@data["mother"])[0].node,
		"reply",
		"basic",
		@data["mother"])
	"#{@json}"
end
get "/mem_test/:a" do
	"#{$post_cache.getcachedlist}\n#{$post_cache.getcachedlist(params[:a])}"
end
