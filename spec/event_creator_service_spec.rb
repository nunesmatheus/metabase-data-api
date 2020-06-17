require 'rails_helper'

RSpec.describe EventCreatorService do
  after { Object.send(:remove_const, :Event) }

  context 'when no custom field is given' do
    it 'defines constant' do
      expect { Event }.to raise_error NameError
      expect(EventCreatorService.call).to eq Event
      expect { Event }.to_not raise_error NameError
    end
  end

  context 'when custom fields are given' do
    let(:fields) { { 'custom_property' => 'value' } }

    it 'defines constant' do
      expect { Event }.to raise_error NameError
      expect(EventCreatorService.call(fields)).to eq Event
      expect(Event.fields.keys).to include 'custom_property'
      expect { Event }.to_not raise_error NameError
    end
  end
end
