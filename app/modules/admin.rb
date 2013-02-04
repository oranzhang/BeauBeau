if Setting.count == 0
	Setting.create!(title: "site_title",data: "Mforum")
	Setting.create!(title: "links",data: "[ { \"title\":\"Oran's Blog\", \"link\": \"http://oranoran.info\" }, { \"title\":\"Mforum on Github\", \"link\": \"https://github.com/oranzhang/Mforum\" } ]")
end
get "/+/admin/home" do
	admin_zone
	@title = i18n.titles.admin
	slim :admin_home
end
post "/+/admin/apply" do
	if admin?
		@titles = params[:titles].split(",")
		@page = "/+/admin/" + params[:page]
		@titles.each do |ti|
			if get_db_settings(ti) == false
				Setting.create!(title: ti,data: params[ti])
			else
				Setting.where(title: ti).update(data: params[ti])
			end
			flash[:notice] = i18n.titles.admin_su(t)
		end
		redirect @page
	end
	admin_zone
end
