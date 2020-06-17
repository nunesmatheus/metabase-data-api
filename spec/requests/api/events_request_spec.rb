require 'rails_helper'

RSpec.describe "Api::Events", type: :request do

  describe "POST /" do
    context 'when information is valid' do
      let!(:event_count) { Event.count }

      before do
        post "/api/events",
             params: {
               name: 'My Event',
               ocurred_at: Time.current - 1.day,
               options: { device_os: 'Android' }
             }
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Event.count).to eq event_count + 1 }
      it { expect(json_response['id']).to eq Event.last.id }
      it { expect(Event.last.options['device_os']).to eq 'Android' }
      it { expect(Event.last.ocurred_at.to_date).to eq Date.yesterday }
    end

    context 'when information is not valid' do
      let!(:event_count) { Event.count }

      before do
        post "/api/events",
             params: { options: { device_os: 'Android' } }
      end

      it { expect(response).to have_http_status(:unprocessable_entity) }
      it { expect(Event.count).to eq event_count }
      it { expect(json_response['id']).to be_nil }
    end
  end
end
