# -*- coding:utf-8 -*-
set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/rack'
require settings.root + '/app/mongo'
require "sinatra-authentication-o"
set :sinatra_authentication_view_path, settings.root + '/ui'
require settings.root + '/app/modules/routes'

