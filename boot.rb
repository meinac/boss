# This is the file which takes care of all dependencies.
require 'bundler'
Bundler.require

require 'active_support/all'
require 'yaml'
require File.expand_path('./easy_conf')

$app_config = EasyConf.app_config

ActiveSupport::Dependencies.autoload_paths += ['app/models', 'app/utils']

Dir["config/initializers/*.rb"].each {|file| require File.expand_path(file) }
Dir["app/*/*.rb"].each {|file| require File.expand_path(file) }
Dir["app/*.rb"].each {|file| require File.expand_path(file) }
