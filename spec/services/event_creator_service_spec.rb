require 'rails_helper'

RSpec.describe EventCreatorService do
  before { Object.send(:remove_const, :Event) }

  context 'when no custom field is given' do
    let(:event_class) { EventCreatorService.call }

    before { expect { Event }.to raise_error NameError }

    it 'defines constant' do
      expect(event_class).to eq Event
      expect { Event }.to_not raise_error NameError
    end

    it 'adds default fields' do
      event_class
      expect(Event.fields.keys).to include 'name'
      expect(Event.fields.keys).to include 'ocurred_at'
    end
  end

  context 'when custom fields are given' do
    let(:fields) { { 'custom_property' => 'value' } }
    let(:event_class) { EventCreatorService.call(fields) }

    before { expect { Event }.to raise_error NameError }

    it 'defines constant' do
      expect { Event }.to raise_error NameError
      expect(event_class).to eq Event
      expect(Event.fields.keys).to include 'custom_property'
      expect { Event }.to_not raise_error NameError
    end

    it 'adds default fields' do
      event_class
      expect(Event.fields.keys).to include 'name'
      expect(Event.fields.keys).to include 'ocurred_at'
    end
  end
end
