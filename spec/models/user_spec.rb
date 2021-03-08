require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of(:password) }

    it 'downcases email' do
      email1 = 'TEST@ME.COM'
      @user = User.create!(email: email1, password: '123abc')

      expect(@user.email).to eq('test@me.com')
    end
  end
end
