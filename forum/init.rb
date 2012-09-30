require 'sinatra'
require "sinatra/cookies"
require 'digest/sha1'
require 'digest/md5'
require "markdown"
require 'mongoid'
require 'json'
require 'aes'
require 'base64' 
require 'memcache'
require './mongo'

config_file = "#{File.dirname(__FILE__)}/config/config.json"
set :views, settings.root + '/ui'
set :public_folder, File.dirname(__FILE__) + '/ui/assets'
$conf = JSON.parse(File.new(config_file,"r").read)[0]
$navi = JSON.parse(File.new(config_file,"r").read)[1]
$aes_key = $conf["cookies_key"]
require './cache'
require './MUtils'
require './routes'
