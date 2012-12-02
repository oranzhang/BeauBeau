set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/cookies'
Mongoid.load!(settings.config_dir + "/mongoid.yml")

get "/" do
	slim :index
end
