class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true

  validates :message, presence: true

  scope :unread, -> { where(read_at: nil) }

  after_create_commit do
    broadcast_prepend_to(
      "user_#{self.user_id}_notifications",
      partial: "notifications/notification",
      locals: { notification: self },
      target: "notifications_list"
    )
  end
end