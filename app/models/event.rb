class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :event_attendances, foreign_key: :attended_event_id
  has_many :attendees, through: :event_attendances, source: :attendee
  has_many :invitations, dependent: :destroy, foreign_key: :event_id, class_name: 'Invitation'
  has_one_attached :image

  scope :past, -> { where('date < ?', Time.now) }
  scope :upcoming, -> { where('date >= ?', Time.now) }

  validates :title, :description, :date, :location, presence: true
  mount_uploader :image, ImageUploader
end
