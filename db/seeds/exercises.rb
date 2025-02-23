I18n.available_locales.each do |locale|
  I18n.with_locale(locale) do
    exercises = [
      "push_ups", "bench_press", "squats", "deadlifts", "pull_ups",
      "lunges", "bicep_curls", "tricep_dips", "lat_pulldown", "shoulder_press",
      "leg_press", "calf_raises", "plank", "rowing_machine", "leg_curl",
      "leg_extension", "hip_thrusts", "dumbbell_fly", "hammer_curl", "preacher_curl",
      "incline_bench_press", "cable_crossovers", "pec_dec", "face_pulls", "rear_delt_fly",
      "chest_dips", "good_mornings", "sumo_deadlift", "romanian_deadlift", "farmer_walk",
      "reverse_lunges", "side_lunges", "box_jumps", "jump_squats", "kettlebell_swings",
      "turkish_getup", "battle_ropes", "sled_push", "medicine_ball_slams",
      "dumbbell_bench_press", "barbell_bench_press", "incline_dumbbell_bench_press", "incline_barbell_bench_press",
      "pec_deck_machine", "ez_bar_curl", "cable_straight_bar_curl", "7x21_bicep_curl",
      "leg_press_machine", "leg_extension_machine", "smith_machine_squat", "hack_squat_machine", "inner_thigh_machine",
      "bent_over_row", "wide_grip_lat_pulldown", "close_grip_triangle_pulldown", "close_grip_triangle_row",
      "skull_crusher_cable", "rope_triceps_pushdown",
      "unilateral_front_raise", "front_raise", "lateral_raise", "free_weight_shoulder_press", "reverse_pec_deck",
      "barbell_shrug", "dumbbell_shrug",
      "romanian_deadlift", "seated_leg_curl", "lying_leg_curl", "unilateral_leg_curl", "sumo_smith_squat", "outer_thigh_machine",
      "close_grip_bench_press", "cable_triceps_pushdown",
      "preacher_curl", "ez_bar_curl_free"
    ]

    exercises.each do |exercise_key|
      Exercise.find_or_create_by!(name: exercise_key) do |exercise|
        exercise.description = I18n.t("exercises.#{exercise_key}.description")
      end
    end
  end
end

puts "✅ Exercise seeds loaded successfully!"
