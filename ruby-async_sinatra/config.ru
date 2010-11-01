# This file is used by Rack-based servers to start the application.
require "rubygems"
require "bundler/setup"

# Require all normal gems
require 'sinatra/async'
require 'em-mysqlplus'

class AsyncTest < Sinatra::Base
  register Sinatra::Async

  configure do
    @@conns = []
    @@index = 0    
    @@number_of_connections = 60
  end
  
  aget '/start' do
    puts "===================================================== 1"
    @@number_of_connections.times do |t|
      @@conns.push(EventMachine::MySQL.new(:host => 'localhost', :database => 'widgets'))
    end
    puts "===================================================== 2"
  end

  aget '/widgets' do
    # @@conn = @@conn.nil? ? EventMachine::MySQL.new(:host => 'localhost', :database => 'widgets') : @@conn
    query = @@conns[@@index].query("select sleep(0.2)")
    @@index = (@@index + 1) % @@number_of_connections
    query.callback do |res|
      body {
        "Hello world"
      }
    end
    
    query.errback {
      |res| body {
        p res.to_s
      }      
    }  

    # query = @@conn.query("select * from test")
    # query.callback do |res|
    #   text = ""
    # 
    #   while row = res.fetch_row
    #     text += row.inspect.to_s
    #   end
    # 
    #   body {
    #     text
    #   }
    # end
    # 
    # query.errback {
    #   |res| body {
    #     p res.to_s
    #   }      
    # }  
  end
end

run AsyncTest.new
