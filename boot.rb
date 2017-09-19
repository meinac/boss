# This is the file which takes care of all dependencies.
require 'bundler'
Bundler.require

require 'active_support/all'
require 'yaml'
require File.expand_path('./easy_conf')

Dir["config/initializers/*.rb"].each {|file| require File.expand_path(file) }
Dir["app/*/*.rb"].each {|file| require File.expand_path(file) }
Dir["app/*.rb"].each {|file| require File.expand_path(file) }

$app_config = EasyConf.app_config
