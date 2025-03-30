class Incident < ApplicationRecord
  SEVERITY_LEVELS = [ "sev0", "sev1", "sev2" ].freeze
  STATUSES = [ "active", "resolved" ].freeze

  validates :title, presence: true
  validates :status, inclusion: { in: STATUSES }
  validates :severity, inclusion: { in: SEVERITY_LEVELS }, allow_nil: true

  def active?
    status == "active"
  end
end
