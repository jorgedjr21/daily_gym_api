require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.new(name: 'Test', email: 'test@example.com', password: 'password', password_confirmation: 'password') }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with an invalid email' do
      subject.email = 'invalid_email'
      expect(subject).not_to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it 'is valid when updating without password' do
      user = create(:user)
      user.name = 'New Name'
      expect(user).to be_valid
    end

    it 'defaults role to member when not set' do
      user = create(:user)
      expect(user.role).to eq('member')
    end

    it 'is valid with role admin' do
      subject.role = 'admin'
      expect(subject).to be_valid
    end

    it 'is not valid with a role outside the allowed list' do
      subject.role = 'superadmin'
      expect(subject).not_to be_valid
    end
  end
end
