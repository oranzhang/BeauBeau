get "/" do
	if File.exists?(settings.config_dir + "/config.json")
		"<p>You Have Installed Successfully!</p><p>Restart the App to make forum works!</p><p>#{File.read(settings.config_dir + "/config.json")}</p>"
	else
		erb :install
	end
end
post "/install" do
	Dir.mkdir settings.config_dir if File.exists?(settings.config_dir) == false
	@data = {:sitename => params[:sitename],:naviname => params[:naviname],:adminuser => params[:adminuser],:adminpass => params[:adminpass], :adminmail => params[:adminmail],:key => OpenSSL::Random.random_bytes(16)}#.inspect}
	file = File.open(settings.config_dir + "/config.json","w+")
	file.puts @data.to_json + "\n" 
	file.close
	"<p>You Have Installed Successfully!</p><p>Restart the App to make forum works!</p><p>#{File.read(settings.config_dir + "/config.json")}</p>"
end