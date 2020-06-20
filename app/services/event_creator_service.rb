class EventCreatorService < ApplicationService
  attr_accessor :custom_fields

  DEFAULT_FIELDS = [
    { name: 'name', type: String },
    { name: 'ocurred_at', type: DateTime },
    { name: 'country', type: String },
    { name: 'state', type: String },
    { name: 'city', type: String },
    { name: 'browser', type: String },
    { name: 'version', type: String },
    { name: 'platform', type: String }
  ]

  def initialize(fields={})
    @custom_fields = fields
  end

  def call
    DynamicCollection.create('Event', fields)
  end

  def fields
    fields = DEFAULT_FIELDS
    custom_fields.each do |option, value|
      fields << { name: option, type: String }
    end
    fields
  end
end
