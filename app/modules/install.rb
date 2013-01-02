# -*- coding:utf-8 -*-
get "/" do
	if File.exists?(settings.config_dir + "/config.json")
		"<p>You Have Installed Successfully!</p><p>Restart the App to make forum works!</p><p>#{File.read(settings.config_dir + "/config.json")}</p><p>#{File.read(settings.config_dir + "/mongoid.yml")}</p>"
	else
		erb :install
	end
end
post "/install" do
	Dir.mkdir settings.config_dir if File.exists?(settings.config_dir) == false
	@mongo = {
		"development" => {"sessions" => {"default" => {"uri" => params[:mongo]}}},
		"production" => {"sessions" => {"default" => {"uri" => params[:mongo]}}},
		"options" => {
			"allow_dynamic_fields" => false,
			"identity_map_enabled" => true,
			"include_root_in_json" => true,
			"include_type_for_serialization" => true,
			"scope_overwrite_exception" => true,
			"raise_not_found_error" => false,
			"skip_version_check" => false,
			"use_activesupport_time_zone" => false,
			"use_utc" => true,
		}
	}
	@data = {:adminmail => params[:adminmail].split(","),:key => OpenSSL::Random.random_bytes(16).inspect}
	file = File.open(settings.config_dir + "/config.json","w+")
	file.puts @data.to_json + "\n" 
	file.close
	file = File.open(settings.config_dir + "/mongoid.yml","w+")
	file.puts @mongo.to_yaml 
	file.close
	"<p>You Have Installed Successfully!</p><p>Restart the App to make forum works!</p><p>#{File.read(settings.config_dir + "/config.json")}</p><p>#{File.read(settings.config_dir + "/mongoid.yml")}</p>"
end