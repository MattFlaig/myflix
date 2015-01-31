require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    amanda = Fabricate(:user)
    sign_in(amanda)
    page.should have_content amanda.full_name
  end

  scenario "with deactivated user" do
    amanda = Fabricate(:user, active: false)
    sign_in(amanda)
    expect(page).not_to have_content(amanda.full_name)
    expect(page).to have_content("Your account has been suspended, please contact customer service.")
  end
end