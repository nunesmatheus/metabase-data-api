class Event < ApplicationRecord
  validates_presence_of :name

  attribute :ocurred_at, :datetime, default: Time.current
end
