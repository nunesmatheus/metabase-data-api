# frozen_string_literal: true

class Event
  include Mongoid::Document

  field :name, type: String
  field :ocurred_at, type: DateTime
  field :country, type: String
  field :state, type: String
  field :city, type: String
  field :browser, type: String
  field :browser_version, type: String
  field :platform, type: String

  before_validation :set_ocurred_at

  validates :name, presence: true

  private

  def set_ocurred_at
    self.ocurred_at ||= Time.current
  end
end
