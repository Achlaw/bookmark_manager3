ENV['RACK_ENV'] ||= 'development'

require 'sinatra/base'
require_relative 'models/link.rb'

require_relative 'data_mapper_setup'


DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "postgres://localhost/bookmark_manager_#{ENV['RACK_ENV']}")
DataMapper.finalize
DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new_link'
  end

  # post '/links/saved' do
  #   Link.create(title: params[:title], url: params[:url])
  #   redirect '/links'
  # end

  post '/links/saved' do
    link = Link.new(url: params[:url], title: params[:title])
    tag = Tag.first_or_create(name: params[:tags])
    link.tags << tag
    link.save
    redirect '/links'
  end
end
