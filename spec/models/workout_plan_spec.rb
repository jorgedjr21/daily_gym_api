require 'rails_helper'

RSpec.describe WorkoutPlan, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }

    it 'ensures workout sessions belong to the same user' do
      user = create(:user)
      other_user = create(:user)

      session1 = create(:workout_session, user: user)
      session2 = create(:workout_session, user: other_user)

      plan = WorkoutPlan.new(name: 'Plan 1', user: user, workout_sessions: [ session1, session2 ])

      expect(plan).not_to be_valid
      expect(plan.errors[:workout_sessions]).to include("must belong to the same user as the workout plan")
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:workout_plan_sessions).dependent(:destroy) }
    it { should have_many(:workout_sessions).through(:workout_plan_sessions) }
  end
end
