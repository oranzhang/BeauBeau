# -*- coding:utf-8 -*-
#modules/post
helpers Mforum::Helpers::Post
get "/" do
	@topics = Topic.page(params[:page]).desc(:last_reply_time)
	slim :index_list 
end
get "/topic/new" do
	slim :new_topic
end
post "/topic/new" do
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
		@time = Time.now
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
get "/topic/:id" do
	@topic =  Topic.where(_id: params[:id])[0]
	@reply_list = get_reply_list params[:id]
	slim :view_topic, :layout => use_layout?
end
