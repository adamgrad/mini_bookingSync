require "rails_helper"

RSpec.feature "User interactions", type: :feature do
  scenario "User signs up successfully" do
    user = FactoryBot.build(:user)
    visit root_path
    click_link "Sign up"
    expect {
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      fill_in "Password confirmation", with: user.password
      click_button "Sign up"
    }.to change(User, :count).by(1)

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario "User logs in successfully" do
    user = FactoryBot.create(:user)
    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
  end
end
