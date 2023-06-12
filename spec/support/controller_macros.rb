# frozen_string_literal: true

module ControllerMacros
  def login_random_user
    before(:each) do
      user = create(:user)
      sign_in user
    end
  end

  def login_user
    before(:each) do
      # @request.env['devise.mapping'] = Devise.mappings[:user]
      # user ||= create(:user)
      # puts defined?(user)
      # if defined?(user).nil?
      #   # puts 'creating user'
      #   user = create(:user)
      # end
      # puts defined?(user)
      sign_in user
    end
  end
end
