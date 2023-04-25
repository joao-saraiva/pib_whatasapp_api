# frozen_string_literal: true

FactoryBot.define do
  factory :player_per_match do
    player_id { FactoryBot.create(:player).id }
    match_id { FactoryBot.create(:match).id }
    position { 1 }

    status { :confirmed }

    trait :pib_priority do
      player_id { FactoryBot.create(:player, :pib_priority).id }
    end

    trait :waiting do
      status { :waiting }
    end

    trait :gived_up do
      status { :gived_up }
    end
  end
end
