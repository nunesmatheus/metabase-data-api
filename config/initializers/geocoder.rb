# frozen_string_literal: true

Geocoder.configure(
  ip_lookup: :ipstack,
  api_key: ENV['IP_STACK_KEY']
)
