# -*- coding:utf-8 -*-
set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/rack'
require settings.root + '/app/mongo'
require "sinatra-authentication-o"
require settings.root + '/app/modules/user'

get "/" do
	slim :index_list 
end
helpers UserUtils
