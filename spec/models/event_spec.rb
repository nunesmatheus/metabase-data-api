require 'rails_helper'

RSpec.describe Event do
  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end