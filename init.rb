ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "ohm"
require "haml"
require "sass"

require 'sinatra_more/markup_plugin'

class Monk::Glue
  register SinatraMore::MarkupPlugin
end

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie
end

Ohm.connect(Main.settings(:redis))

require 'pathname'
require 'dsl_accessor'
require 'ohm-arfreaks'

Dir[Main.root_path("lib/**/*.rb")].each do |file|
  require file
end

# Load all application files.
Dir[Main.root_path("app/**/*.rb")].each do |file|
  require file
end

file = Main.root_path("config/local.rb")
if File.exist?(file)
  require file
end

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
end

Main.run! if Main.run?
