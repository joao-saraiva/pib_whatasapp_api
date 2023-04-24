require 'rails_helper'

RSpec.describe PlayerPerMatch, type: :model do
  it { should belong_to(:player).required(true) }
  it { should belong_to(:match).required(true) }

  it { should define_enum_for(:status).with_values([:confirmed, :waiting, :gived_up]) }


  %i[status position].each do |attribute|
    it { should validate_presence_of(attribute) }
  end
end