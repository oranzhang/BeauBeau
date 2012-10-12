get "/install" do
	if File.exists? config_dir + "/config.json"
	"Install"
	else
	erb :install
	end
end
post "/install" do
	@data = {:sitename => params[:sitename],:naviname => params[:naviname],:adminuser => params[:adminuser],:adminpass => params[:adminpass], :adminmail => params[:adminmail],:key => OpenSSL::Random.random_bytes(16)}#.inspect}
	file = File.open(config_dir + "/config.json","w+")
	file.puts @data.to_json + "\n" 
	file.close
	"You Have Installed Successfully! \n #{File.read(config_dir + "/config.json")}"
end