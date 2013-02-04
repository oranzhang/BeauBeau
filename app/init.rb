# -*- coding:utf-8 -*-
set :config , JSON.parse(File.open(settings.config_dir + "/config.json").read)
$admins = settings.config["adminmail"]
require settings.root + '/app/modules/rack'
require 'sinatra/r18n'
R18n::I18n.default = 'en'
R18n.default_places { "#{settings.root}/i18n/" }
before do
  session[:locale] = params[:locale] if params[:locale]
end
require 'rdiscount'
require 'kaminari'
require 'kaminari/sinatra'
helpers Kaminari::Helpers::SinatraHelpers
require settings.root + '/app/mongo'
require "sinatra-authentication-o"
set :sinatra_authentication_view_path, settings.root + '/ui'
require settings.root + '/app/modules/utils'
require settings.root + '/app/modules/admin'
require settings.root + '/app/modules/routes'
require settings.root + '/app/modules/post'
