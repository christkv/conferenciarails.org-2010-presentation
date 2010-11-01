class WidgetsController < ApplicationController
  def index
    Widget.find_by_sql("select sleep(0.2)")
    # text = ""
    # entries = Widget.find(:all)
    # entries.each do |entry|
    #   text += ([entry.id, entry.name]).to_s
    # end
    # render :text => text
    render :text => "Hello world"
  end
end
