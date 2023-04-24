require 'rails_helper'

RSpec.describe Match, type: :model do
  %i[date status].each do |field|
    it { should validate_presence_of(field) }
  end

  it { should define_enum_for(:status).with_values([:open, :closed, :cancelled]) }
end
