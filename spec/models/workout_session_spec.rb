require 'rails_helper'

RSpec.describe WorkoutSession, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:workout_session_exercises).dependent(:destroy) }
    it { should have_many(:exercises).through(:workout_session_exercises) }
    it { should have_many(:workout_plan_sessions).dependent(:destroy) }
    it { should have_many(:workout_plans).through(:workout_plan_sessions) }
  end
end
