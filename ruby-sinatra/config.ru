# This file is used by Rack-based servers to start the application.
require "rubygems"
require "bundler/setup"

# Require all normal gems
require 'sinatra/async'
require 'em-mysqlplus'

# conn = nil

# EventMachine.run {
  # conn = EventMachine::MySQL.new(:host => 'localhost')
# }

class AsyncTest < Sinatra::Base
  register Sinatra::Async

  # configure do
  #   conn = EventMachine::MySQL.new(:host => 'localhost')
  # end

  aget '/' do
    body "hello async"
  end

  aget '/delay/:n' do |n|
    conn = conn.nil? ? EventMachine::MySQL.new(:host => 'localhost', :database => 'widgets') : conn
    # EM.add_timer(n.to_i) { body { "delayed for #{n} seconds" } }
    query = conn.query("select * from test")
    query.callback do |res|
      text = ""

      while row = res.fetch_row
        text += row.inspect.to_s
      end

      body {
        text
      }
    end
    
    query.errback {
      |res| body {
        p res.to_s
      }      
    }  
  end
end

run AsyncTest.new
