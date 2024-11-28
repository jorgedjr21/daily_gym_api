require 'rails_helper'

RSpec.describe Exercise, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:workout_session_exercises) }
    it { should have_many(:workout_sessions).through(:workout_session_exercises) }
  end
end
