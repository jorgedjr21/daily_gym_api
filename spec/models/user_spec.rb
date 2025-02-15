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
  end
end
