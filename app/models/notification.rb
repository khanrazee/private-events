class Notification < ApplicationRecord
  belongs_to :recipient, class_name: 'User'
  belongs_to :actor, class_name: 'User'
  belongs_to :notifiable, polymorphic: true, dependent: :destroy

  scope :unread, -> { where(read_at: nil) }
end
