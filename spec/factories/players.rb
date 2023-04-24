FactoryBot.define do
  factory :player do
    number { "MyString" }
    name { "MyString" }
    pib_priority { false }


    trait :inveted_friend do 
      number { nil }
      player_friend_id { FactoryBot.create(:player).id }
    end

    trait :pib_priority do 
      pib_priority { true }
    end
  end
end
