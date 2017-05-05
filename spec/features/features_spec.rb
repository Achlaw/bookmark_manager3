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
    visit '/links/new'
    fill_in 'title', with: 'makers'
    fill_in 'url', with: 'makersacademy.com'
    fill_in 'tags', with: 'search_engine'
    click_button 'new link'
    link = Link.first
                save_and_open_page
    # expect(page).to have_content 'search engine'
    expect(link.tags.map(&:name)).to include ('search_engine')
    DatabaseCleaner.clean
  end
  scenario 'I can add multiple tags and view through multiple filters' do
    visit '/links/new'
    fill_in 'title', with: 'makers'
    fill_in 'url', with: 'makersacademy.com'
    fill_in 'tags', with: 'search_engine, education, sports'
    visit 'links/search_engine'
    expect(page).to have_content 'makersacademy.com'
    visit 'links/education'
    expect(page).to have_content 'makersacademy.com'
    click_button 'new link'
  end

  feature 'Viewing tags' do
    scenario 'I can filter by tags' do
      DatabaseCleaner.start
      visit '/links/new'
      fill_in 'title', with: 'makers'
      fill_in 'url', with: 'makersacademy.com'
      fill_in 'tags', with: 'search_engine'
      click_button 'new link'
      visit '/links/search_engine'
      expect(page).to have_content 'makersacademy.com'
      DatabaseCleaner.clean
    end
  end
end
