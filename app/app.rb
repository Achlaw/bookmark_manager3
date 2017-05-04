ENV['RACK_ENV'] ||= 'development'
require 'sinatra/base'
require_relative 'models/link.rb'

class BookmarkManager < Sinatra::Base

  get '/' do
    redirect 'links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new_link'
  end

  post '/links/saved' do
    Link.create(title: params[:title], url: params[:url])
    redirect '/links'
  end
end
