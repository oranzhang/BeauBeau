# -*- coding:utf-8 -*-
require 'sinatra'
require "slim"
require 'mongoid'
require 'digest/sha1'
require 'digest/md5'
require 'json'
require 'memcache'
require 'rack-flash'


configure do
    set :template_engine, "slim" # for example
end
set :config_dir , settings.root + "/config"
set :views, settings.root + '/ui'
set :public_folder, settings.root + '/assets'

require settings.root + '/app/modules/install' if File.exist?(settings.config_dir + "/config.json") == false
require settings.root + '/app/init' if File.exist?(settings.config_dir + "/config.json")
