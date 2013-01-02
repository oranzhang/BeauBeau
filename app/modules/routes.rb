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
get "/me" do
	@title = "我"
	login_required
	slim :user_settings, :layout => use_layout?
end
post "/pass" do
	@title = "我"
	login_required
    redirect "/users" unless admin? || current_user.id.to_s == params[:id]
    user = User.get(:id => params[:id])
    user_attributes = params[:user]
    if user.update(user_attributes)
      if Rack.const_defined?('Flash')
        flash[:notice] = '修改成功'
      end
      redirect '/me'
    else
      if Rack.const_defined?('Flash')
        flash[:error] = "#{user.errors}"
      end
      redirect "/"
    end
end