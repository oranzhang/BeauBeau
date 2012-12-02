set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/cookies'
require settings.root + '/app/mongo'
require settings.root + '/app/modules/user'

get "/" do
	slim :index_list 
end
helpers UserUtils
