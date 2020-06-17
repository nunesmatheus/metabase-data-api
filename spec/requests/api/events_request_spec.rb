require 'rails_helper'

RSpec.describe Api::EventsController do
  describe '#create' do
    context 'with required params' do
      before do
        post '/api/events',
             params: { name: 'My Custom Event',
                       options: { 'custom_property' => 'value' } }
      end

      it { expect(response).to have_http_status :ok }
      it { expect(Event.last.name).to eq 'My Custom Event' }
      it { expect(Event.last.custom_property).to eq 'value' }
      it { expect(Event.count).to eq 1 }
    end

    context 'without required params' do
      before { post '/api/events' }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(json_response['error']).to include 'name' }
      it { expect(Event.count).to eq 0 }
    end
  end
end
