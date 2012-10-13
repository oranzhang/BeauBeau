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

require settings.root + '/app/modules/install' if File.exist?(config_dir + "/config.json") == false
require settings.root + '/app/init' if File.exist?(config_dir + "/config.json")
