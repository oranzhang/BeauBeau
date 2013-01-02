# -*- coding:utf-8 -*-
#modules/post
get "/" do
	@title = "首页"
	@topics = Topic.page(params[:page]).desc(:last_reply_time)
	slim :index_list 
end
get "/topic/new" do
	@title = "新话题"
	slim :new_topic
end
post "/topic/new" do
	@title = "新话题"
	@data = params[:topic]
	if @data[:title]!="" && @data[:texts]!="" && @data[:tags] != ""
		@tags = @data[:tags].split(%r{,\s*})
		@tags_s = []
		@tags.each do |x|
			@t = Tag.where(name: x)
			if @t.exists?
				if @t[0].link_to == ""
					@tags_s << @t[0].name
				else
					@tags_s << @t[0].link_to
				end
			else
				Tag.create!(name: x,link_to: "")
				@tags_s << x
			end
		end
		@tags_u = @tags_s.uniq
		@time = Time.now.utc
		post = Topic.new(title: @data[:title] ,
				tags: @tags_u,
				texts: @data[:texts] ,
				user: current_user.name ,
				last_reply_time: @time,
				status: "topic",
				time: @time)
		post.save
		flash[:notice] = "发表成功！"
		redirect "/topic/#{post[:_id]}"
	else
		flash[:error] = "请不要留空哟！"
		slim :new_topic
	end
end
post "/topic/reply/new" do
	@data = params[:reply]
	if @data[:texts]!="" && @data[:belong_to] != ""
		@time = Time.now.utc
		reply = Reply.new(texts: @data[:texts],
			time: @time,
			user: current_user.name,
			belong_to: @data[:belong_to])
		reply.save
		flash[:notice] = "发表成功！"
		Topic.where(_id:@data[:belong_to]).update(:last_reply_time => @time)
		@notice = "true"
	else
		@notice = "false"
	end
	@notice
end
get "/topic/:id" do
	if Topic.where(_id: params[:id]).count == 0
		redirect 404
	else
		@topic =  Topic.where(_id: params[:id])[0]
		@title = @topic.title
		@replies = get_reply_list(params[:id]).page(params[:page]).desc(:time)
		slim :view_topic, :layout => use_layout?
	end
end
