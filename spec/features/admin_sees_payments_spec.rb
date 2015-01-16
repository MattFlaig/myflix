require 'spec_helper'

feature 'admin sees payments' do 

  background do 
    amanda = Fabricate(:user, full_name: "Amanda Sander", email: "amanda@amanda.com")
    Fabricate(:payment, amount: 999, user: amanda)
  end

  scenario 'Admin can see payments' do 
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content("€ 9.99")
    expect(page).to have_content("Amanda Sander")
    expect(page).to have_content("amanda@amanda.com")
  end

  scenario 'user cannot see payments' do 
    user = Fabricate(:user)
    sign_in(user)
    visit admin_payments_path
    expect(page).not_to have_content("€ 9.99")
    expect(page).not_to have_content("Amanda Sander")
    expect(page).to have_content("You are not authorized to do that!")
  end

end