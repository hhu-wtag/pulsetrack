class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  scope :unread, -> { where(read_at: nil) }
end