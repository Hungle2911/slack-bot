class Incident < ApplicationRecord
  SEVERITY_LEVELS = [ "sev0", "sev1", "sev2" ].freeze
  STATUSES = [ "active", "resolved" ].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :severity, inclusion: { in: SEVERITY_LEVELS }, allow_nil: true

  scope :active, -> { where(status: "active") }
  scope :resolved, -> { where(status: "resolved") }

  def resolve!
    update!(
      status: "resolved",
      resolved_at: Time.current
    )
  end

  def resolution_time
    return nil unless resolved_at && created_at

    seconds = (resolved_at - created_at).to_i

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60

    if hours > 0
      "#{hours}h #{minutes}m"
    else
      "#{minutes}m"
    end
  end

  def active?
    status == "active"
  end
end
