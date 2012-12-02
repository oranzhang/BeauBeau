set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/cookies'
require settings.root + '/app/mongo'

get "/" do
	slim :index
end
