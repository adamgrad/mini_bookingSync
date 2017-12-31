require "rails_helper"

RSpec.feature "Token obtaining", type: :feature do
  scenario "User gets token when authorized" do
    user = FactoryBot.create(:user)
    visit root_path
    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"

    expect(page).to have_content "Signed in successfully."
    expect(page).to have_content "Authentication Token: #{ENV['API_TOKEN']}"
  end

  scenario "User doesn't get token when unauthorized" do
    visit root_path
    expect(page).to have_content "Log in to view content."
  end
end
