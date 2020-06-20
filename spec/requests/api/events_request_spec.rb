require 'rails_helper'

RSpec.describe Api::EventsController do
  describe '#create' do
    context 'with required params' do
      context 'with options' do
        before do
          allow_any_instance_of(ActionDispatch::Request).to(
            receive(:ip).and_return('172.217.172.206'))
          post '/api/events',
               params: { name: 'My Custom Event',
                         options: { 'custom_property' => 'value' } }
        end

        it { expect(response).to have_http_status :ok }
        it { expect(Event.last.name).to eq 'My Custom Event' }
        it { expect(Event.last.custom_property).to eq 'value' }
        it { expect(Event.count).to eq 1 }

        it 'persists geolocation data' do
          expect(Event.last.country).to be_present
          expect(Event.last.state).to be_present
          expect(Event.last.city).to be_present
        end
      end

      context 'without options' do
        before do
          post '/api/events', params: { name: 'My Custom Event' }
        end

        it { expect(response).to have_http_status :ok }
        it { expect(Event.last.name).to eq 'My Custom Event' }
        it { expect(Event.count).to eq 1 }
      end
    end

    context 'without required params' do
      before { post '/api/events' }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(json_response['error']).to include 'name' }
      it { expect(Event.count).to eq 0 }
    end
  end
end
