FactoryBot.define do
  factory :player do
    number { "MyString" }
    name { "MyString" }

    trait :inveted_friend do 
      number { nil }
      player_friend_id { FactoryBot.create(:player).id }
    end
  end
end
