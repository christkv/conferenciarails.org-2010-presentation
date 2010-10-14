class WidgetsController < ApplicationController
  def index
    text = ""
    entries = Widget.find(:all)
    entries.each do |entry|
      text += ([entry.id, entry.name]).to_s
    end
    render :text => text
  end
end