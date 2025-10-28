class MonitoredSite < ApplicationRecord
  belongs_to :user
  has_many :check_results, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  enum :last_status, { pending: 0, up: 1, down: 2 }

  validates :name, presence: true
  validates :url, presence: true, url: {
    schemes: %w[http https],
    no_local: true
  }

  private
end
