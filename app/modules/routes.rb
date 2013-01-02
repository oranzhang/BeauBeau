# -*- coding:utf-8 -*-
get "/users_gallery" do
	@title = "谁在这儿？"
	slim :users_gallery
end
get "/~:name" do
	if MongoidUser.where(name: params[:name]).exists?
		@user = MongoidUser.where(name: params[:name])[0]
		@title = @user.name
		slim :user_page, :layout => use_layout?
	else
		redirect 404
	end
end
