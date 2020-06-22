# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventCreatorService do
  context 'when no custom field is given' do
    let(:event_class) { EventCreatorService.call }

    it 'defines constant' do
      expect(event_class).to eq CustomEvent
      expect { CustomEvent }.to_not raise_error NameError
    end

    it 'inherits default fields' do
      event_class
      expect(CustomEvent.fields.keys).to include 'name'
      expect(CustomEvent.fields.keys).to include 'ocurred_at'
    end

    it 'when constant has been defined already' do
      EventCreatorService.call
      EventCreatorService.call
      expect(Object.constants).to include :CustomEvent
    end
  end

  context 'when custom fields are given' do
    let(:fields) { { 'custom_property' => 'value' } }
    let(:event_class) { EventCreatorService.call(fields) }

    it 'defines constant' do
      expect(event_class).to eq CustomEvent
      expect(CustomEvent.fields.keys).to include 'custom_property'
      expect { CustomEvent }.to_not raise_error NameError
    end

    it 'inherits default fields' do
      event_class
      expect(CustomEvent.fields.keys).to include 'name'
      expect(CustomEvent.fields.keys).to include 'ocurred_at'
    end
  end
end
