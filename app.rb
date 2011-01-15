require 'rubygems'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'hpricot'
require 'rockstar'
require 'json'
require 'active_support'

configure do  
  # set last update time
  @@last_updated = Time.now
  
  # initialise api key
  Rockstar.lastfm = YAML.load_file('lastfm.yml')

  # get my user id
  @@user = Rockstar::User.new('markturner')
  
  # get albums
  @@albums = @@user.weekly_album_chart
  
end

get '/' do
  array = []
  
  @@albums.each do |a|
    # need to come up with a way of getting track count, as this has been removed from last.fm api!
    
    # pushes played albums to an array
    if a.playcount.to_i >= 7
      array << {
        :title => a.name,
        :artist => a.artist,
        :play_count => a.playcount,
        :url => a.load_info[:url],
        :image_url => a.load_info[:image_url]
      }
    end
  end
  
  # return array as json object
  array.to_json
  
end