# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::EventsController do
  describe '#create' do
    context 'with required params' do
      context 'with options' do
        before do
          allow_any_instance_of(ActionDispatch::Request).to(
            receive(:remote_ip).and_return('172.217.172.206')
          )
          VCR.use_cassette 'geolocation' do
            post '/api/events',
                 headers: { 'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5' },
                 params: { name: 'My Custom Event', options: { 'custom_property' => 'value' } }
          end
        end

        it { expect(response).to have_http_status :ok }
        it { expect(Event.last.name).to eq 'My Custom Event' }
        it { expect(Event.last.custom_property).to eq 'value' }
        it { expect(Event.count).to eq 1 }

        it 'persists geolocation data' do
          expect(Event.last.country).to eq 'Brazil'
          expect(Event.last.state).to eq 'São Paulo'
          expect(Event.last.city).to eq 'Guarulhos'
        end

        it 'persists browser data' do
          expect(Event.last.browser).to be_present
          expect(Event.last.browser_version).to be_present
          expect(Event.last.platform).to be_present
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
