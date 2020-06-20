# frozen_string_literal: true

class EventCreatorService < ApplicationService
  attr_accessor :custom_fields

  DEFAULT_FIELDS = [
    { name: 'name', type: String },
    { name: 'ocurred_at', type: DateTime },
    { name: 'country', type: String },
    { name: 'state', type: String },
    { name: 'city', type: String },
    { name: 'browser', type: String },
    { name: 'browser_version', type: String },
    { name: 'platform', type: String }
  ].freeze

  def initialize(fields = {})
    @custom_fields = fields
  end

  def call
    DynamicCollection.create('Event', fields)
  end

  def fields
    fields = DEFAULT_FIELDS
    custom_fields.each do |option, _value|
      fields << { name: option, type: String }
    end
    fields
  end
end
