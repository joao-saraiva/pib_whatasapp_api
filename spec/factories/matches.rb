# frozen_string_literal: true

FactoryBot.define do
  factory :match do
    status { :open }
    date { '2023-04-24' }
  end
end
