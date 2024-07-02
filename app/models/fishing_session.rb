class FishingSession < ApplicationRecord
  belongs_to :user
  belongs_to :fishing_place
  has_many :catches

  validates :start_at, presence: true
  validates :end_at, comparison: { greater_than: :start_at }, allow_blank: true

  private

  def self.duration_all_sessions(user_id)
    fishing_sessions = FishingSession.where(user_id: user_id)
    duration_seconds = 0
    fishing_sessions.each do |fishing_session|
      fishing_session.end_at = DateTime.now if fishing_session.end_at == nil
      duration_seconds += (fishing_session.end_at - fishing_session.start_at).abs
    end
    duration_days = (duration_seconds / 86400).to_i
    duration_day_seconds = (duration_seconds % 86400)
    duration_time = Time.at(duration_day_seconds).utc.strftime "%H:%M"    
    "#{duration_days} #{I18n.t('statistic.duration_days')} #{duration_time}"
  end
end
