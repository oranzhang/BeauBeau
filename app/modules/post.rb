# -*- coding:utf-8 -*-
#modules/post
get "/" do
	@title = i18n.titles.home
	@topics = Topic.page(params[:page]).desc(:last_reply_time)
	slim :index_list 
end
get "/topic/new" do
	@title = i18n.titles.newp
	slim :new_topic
end
post "/topic/new" do
	@title = i18n.titles.newp
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
		flash[:notice] = i18n.titles.new_su
		redirect "/topic/#{post[:_id]}"
	else
		flash[:error] = i18n.titles.new_em
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
		flash[:notice] = i18n.titles.new_su
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
get "/conn/:name" do
	@t = Tag.where(name: params[:name])
	if @t.exists?
		if @t[0].link_to == ""
			@tag = @t[0].name
		else
			@tag = @t[0].link_to
		end
		@pt = params[:name]
		@query = [@tag]
		Tag.where(link_to: @tag).each {|x|@query<<x.name}
		@title = "Tagged as " + @tag
		@topics = Topic.any_in(:tags => @query).page(params[:page]).desc(:last_reply_time)
		slim :conn_list
	else
		flash[:notice] = i18n.titles.not_tag(params[:name])
		redirect "/"
	end
end
get "/conn" do 
	slim :view_conn
end
post "/conn" do
	@p = "/conn" + params[:page]
	@o = params[:old_tag]
	@n = params[:new_tag]
	if @o == @n 
		flash[:error] = i18n.titles.l_same
	else
		if Tag.where(name: @o).exists?
			Tag.create!(name:@n,link_to: "") if Tag.where(name: @n).count == 0
			Tag.where(name: @o).update(link_to: @n)

			flash[:notice] = i18n.titles.l_su
		else
			flash[:error] = i18n.titles.l_inv
		end
	end
	redirect @p
end
