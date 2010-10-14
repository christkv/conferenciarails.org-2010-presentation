# This file is used by Rack-based servers to start the application.
require "rubygems"
require "bundler/setup"

# Require all normal gems
require 'sinatra'
require 'mysql'

class AsyncTest < Sinatra::Base
  configure do
    @@conn = nil
  end

  get '/delay/:n' do |n|
    @@conn = @@conn.nil? ? Mysql.connect("localhost", "root", "", "widgets") : @@conn
    text = ""

    # execute query
    res = query = @@conn.query("select * from test")

    while row = res.fetch_row
      text += row.inspect.to_s
    end
      
    text
  end
end

run AsyncTest.new
