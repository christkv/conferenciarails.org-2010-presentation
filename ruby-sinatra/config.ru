# This file is used by Rack-based servers to start the application.
require "rubygems"
require "bundler/setup"

# Require all normal gems
require 'sinatra'
require 'mysql'

class AsyncTest < Sinatra::Base
  configure do
    @@conns = []
    @@index = 0    

    puts "===================================================== 1"
    100.times do |t|
      @@conns.push(Mysql.connect("localhost", "root", "", "widgets"))
    end
    puts "===================================================== 2"
  end

  get '/widgets' do
    # @@conn = @@conn.nil? ? Mysql.connect("localhost", "root", "", "widgets") : @@conn
    # execute query
    @@conns[@@index].query("select sleep(0.2)")
    @@index = (@@index + 1) % 100

    "Hello world"
    # 
    # @@conn = @@conn.nil? ? Mysql.connect("localhost", "root", "", "widgets") : @@conn
    # text = ""
    # 
    # # execute query
    # res = query = @@conn.query("select * from test")
    # 
    # while row = res.fetch_row
    #   text += row.inspect.to_s
    # end
    #   
    # text
  end
end

run AsyncTest.new
