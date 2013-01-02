if Setting.count == 0
	Setting.create!(title: "site_title",data: "Mforum")
	Setting.create!(title: "links",data: ""[ { \"title\":\"Oran's Blog\", \"link\": \"http://oranoran.info\" }, { \"title\":\"Mforum on Github\", \"link\": \"https://github.com/oranzhang/Mforum\" } ]"")
end
get "/+/admin/home" do
	admin_zone
	@title = "Administartion"
	slim :admin_home
end
post "/+/admin/apply" do
	if admin?
		@titles = params[:titles].split(",")
		@page = "/+/admin/" + params[:page]
		@titles.each do |t|
			if get_db_settings(t) == false
				Setting.create!(title: t,data: params[t])
			else
				Setting.where(title: t).update(data: params[t])
			end
			flash[:notice] = "Administartion: #{t} has been modified!"
		end
		redirect @page
	end
	admin_zone
end
