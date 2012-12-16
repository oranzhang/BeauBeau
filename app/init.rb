# -*- coding:utf-8 -*-
set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
require settings.root + '/app/modules/rack'

require 'kaminari'
require 'kaminari/sinatra'
helpers Kaminari::Helpers::SinatraHelpers
require settings.root + '/app/mongo'
require "sinatra-authentication-o"
set :sinatra_authentication_view_path, settings.root + '/ui'
require settings.root + '/app/modules/utils'
require settings.root + '/app/modules/routes'
require settings.root + '/app/modules/post'
