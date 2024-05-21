class Invitation < ApplicationRecord
  belongs_to :event
  belongs_to :invitee, class_name: 'User'

  validates :event_id, :invitee_id, presence: true

  scope :pending, -> { where(status: :pending) }

  enum :status, [:pending, :accepted, :declined, :maybe]
end
