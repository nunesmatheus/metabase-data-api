require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#create' do
    let(:event) { Event.new(name: 'My Event') }

    context 'when ocurred_at is given' do
      before do
        event.ocurred_at = Time.current - 1.day
        event.save!
      end

      it { expect(event.ocurred_at.to_date).to eq (Time.current - 1.day).to_date }
    end

    context 'when ocurred_at is NOT given' do
      before { event.save! }

      it { expect(event.ocurred_at.to_date).to eq Time.current.to_date }
    end
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:options) }
  end
end
