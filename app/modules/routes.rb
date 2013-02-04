# -*- coding:utf-8 -*-
get "/users_gallery" do
	@title = i18n.titles.ug
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
	@title = i18n.titles.me
	login_required
	slim :user_settings, :layout => use_layout?
end
post "/pass" do
	@title = i18n.titles.su
	login_required
    redirect "/users" unless admin? || current_user.id.to_s == params[:id]
    user = User.get(:id => params[:id])
    user_attributes = params[:user]
    if user.update(user_attributes)
      if Rack.const_defined?('Flash')
        flash[:notice] = i18n.titles.me
      end
      redirect '/me'
    else
      if Rack.const_defined?('Flash')
        flash[:error] = "#{user.errors}"
      end
      redirect "/"
    end
end