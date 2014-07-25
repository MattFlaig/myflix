require 'spec_helper'

feature 'admin adds new video' do 
  scenario 'Admin successfully adds a new video' do 
    admin = Fabricate(:admin)
    thriller = Fabricate(:category, name: "Thriller")
    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Lost Highway"
    select "Thriller", from: "Category"
    fill_in "Description", with: "Nightmare"
    attach_file "Large cover", "spec/support/uploads/losthighwayquadlarge.jpg"
    attach_file "Small cover", "spec/support/uploads/lost_highway.jpg"
    fill_in "Video URL", with: 'http://www.example.com/my_video.mp4'
    click_button "Add Video"

    sign_out
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/losthighwayquadlarge.jpg']")
    expect(page).to have_link("", href="http://www.example.com/my_video.mp4")
    #expect(page).to have_selector("a[href='http://www.example.com/my_video.mp4']")
  end

end