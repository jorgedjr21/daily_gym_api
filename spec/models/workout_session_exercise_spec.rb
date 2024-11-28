require 'rails_helper'

RSpec.describe WorkoutSessionExercise, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:sets) }
    it { should validate_presence_of(:reps) }
    it { should validate_numericality_of(:current_weight).is_greater_than_or_equal_to(0).allow_nil }
  end

  describe 'associations' do
    it { should belong_to(:workout_session) }
    it { should belong_to(:exercise) }
  end
end
