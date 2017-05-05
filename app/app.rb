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

    tagarray = params[:tags].split(',') #[tag1,tag2,tag3]



  #  tag = Tag.first_or_create(name: params[:tags])
    tagarray.each do |tag|
      link.tags << Tag.first_or_create(tag)
      link.save
    end

    #link.tags << tag
    #link.save
    redirect '/links'
  end

  get '/links/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end
end
