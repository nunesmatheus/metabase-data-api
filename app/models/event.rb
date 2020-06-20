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

  validates :name, presence: true

  before_validation :set_ocurred_at

  private

  def set_ocurred_at
    self.ocurred_at ||= Time.current
  end
end