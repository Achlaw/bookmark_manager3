require './app/app.rb'
require 'database_cleaner'

feature 'Viewing links' do
  scenario 'I can see existing links on the links page' do
    DatabaseCleaner.start
    Link.create(url: 'http://www.google.com', title: 'Google')
    visit '/links'
    expect(page).to have_content('Google')
    DatabaseCleaner.clean
  end
end

feature 'Creating tags' do
  scenario 'I can add tags to a url' do
    DatabaseCleaner.start
    visit 'links/new'
    fill_in 'title', with: 'makers'
    fill_in 'url', with: 'makersacademy.com'
    fill_in 'tag', with: 'search engine'
            save_and_open_page
    click_button 'new link'
    expect(page).to have_content 'search engine'
    DatabaseCleaner.clean
  end
end
