# -*- coding:utf-8 -*-
require "rubygems"
require "bundler/setup"
require 'sinatra'
require "sinatra_more/markup_plugin"
require "sinatra_more/render_plugin"
require "sinatra_more/routing_plugin"
require "slim"
require "coffee-script"
require 'digest/sha1'
require 'digest/md5'
require 'json'
require 'rack-flash'
require 'padrino-helpers'
configure do
    set :template_engine, "slim" # for example
end
set :config_dir , settings.root + "/config"
set :views, settings.root + '/ui'
set :public_folder, settings.root + '/assets'
require settings.root + '/app/modules/install' if File.exist?(settings.config_dir + "/config.json") == false
require settings.root + '/app/init' if File.exist?(settings.config_dir + "/config.json")