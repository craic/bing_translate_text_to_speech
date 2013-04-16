# Run this with 'rackup -p 4567'

require 'bundler'
Bundler.require

require 'sinatra'

require './html5_app.rb'

run Html5App.new
