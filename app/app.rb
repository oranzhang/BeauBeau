require 'sinatra'
require 'encrypted_cookie'
require 'digest/sha1'
require 'digest/md5'
require "markdown"
require 'mongoid'
require 'json'
require 'aes'
require 'base64' 
require 'memcache'
set :config_dir , settings.root + "/config"
set :views, settings.root + '/ui'
set :public_folder, settings.root + '/assets'

require settings.root + '/app/modules/install' if File.exist?(settings.config_dir + "/config.json") == false
require settings.root + '/app/init' if File.exist?(settings.config_dir + "/config.json")
