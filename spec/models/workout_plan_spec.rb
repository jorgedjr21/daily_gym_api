require 'rails_helper'

RSpec.describe WorkoutPlan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:workout_sessions).dependent(:destroy) }
  end
end
