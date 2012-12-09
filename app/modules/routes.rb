get "/" do
	slim :index_list 
end
get "/users_gallery" do
	slim :users_gallery
end
get "/+:name" do
	if MongoidUser.where(name: params[:name]).exists?
		@user = MongoidUser.where(name: params[:name])[0]
		slim :user_page
	else
		redirect 404
	end
end
get "/~:name" do
	if MongoidUser.where(name: params[:name]).exists?
		@user = MongoidUser.where(name: params[:name])[0]
		slim :user_page, :layout => use_layout?
	else
		redirect 404
	end
end