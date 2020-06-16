require 'rails_helper'

RSpec.describe Event, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:options) }
  end
end
