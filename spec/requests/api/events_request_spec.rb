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
        it { expect(CustomEvent.last.name).to eq 'My Custom Event' }
        it { expect(CustomEvent.last.custom_property).to eq 'value' }
        it { expect(CustomEvent.last.ocurred_at.to_date).to eq Time.zone.today }
        it { expect(CustomEvent.count).to eq 1 }

        it 'persists geolocation data' do
          expect(CustomEvent.last.country).to eq 'Brazil'
          expect(CustomEvent.last.state).to eq 'São Paulo'
          expect(CustomEvent.last.city).to eq 'Guarulhos'
        end

        it 'persists browser data' do
          expect(CustomEvent.last.browser).to be_present
          expect(CustomEvent.last.browser_version).to be_present
          expect(CustomEvent.last.platform).to be_present
        end
      end

      context 'without options' do
        before do
          post '/api/events', params: { name: 'My Custom Event',
                                        ocurred_at: Time.zone.tomorrow }
        end

        it { expect(response).to have_http_status :ok }
        it { expect(CustomEvent.last.name).to eq 'My Custom Event' }
        it { expect(CustomEvent.last.ocurred_at.to_date).to eq Time.zone.tomorrow }
        it { expect(CustomEvent.count).to eq 1 }
      end

      context 'with invalid information' do
        before do
          post '/api/events', params: { name: '' }
        end

        it { expect(response).to have_http_status :unprocessable_entity }
        it { expect(json_response['errors']['name']).to be_present }
      end
    end

    context 'without required params' do
      before { post '/api/events' }

      it { expect(response).to have_http_status :unprocessable_entity }
      it { expect(json_response['error']).to include 'name' }
      it { expect(CustomEvent.count).to eq 0 }
    end

    context 'when api token env var is present' do
      let(:token) { SecureRandom.hex }

      before { ENV['API_TOKEN'] = token }

      context 'and api token is sent' do
        context 'and is correct' do
          before do
            post '/api/events',
                 headers: { Authorization: "Bearer #{token}" },
                 params: { name: 'My Custom Event',
                           ocurred_at: Time.zone.tomorrow }
          end

          it { expect(response).to have_http_status :ok }
        end

        context 'but is incorrect' do
          before do
            post '/api/events',
                 headers: { Authorization: 'Bearer 123456' },
                 params: { name: 'My Custom Event',
                           ocurred_at: Time.zone.tomorrow }
          end

          it { expect(response).to have_http_status :unauthorized }
        end
      end

      context 'and api token is not sent' do
        before do
          post '/api/events',
               params: { name: 'My Custom Event',
                         ocurred_at: Time.zone.tomorrow }
        end

        it { expect(response).to have_http_status :unauthorized }
      end
    end
  end
end
