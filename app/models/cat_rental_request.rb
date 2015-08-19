class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: %w(PENDING APPROVED DENIED)
  # validate :approve?, on: :update
  validate :has_no_overlapping_approved_requests
  belongs_to :cat

  after_initialize do |request|
    request.status ||= "PENDING"
  end

  def approve!
    ActiveRecord::Base.transaction do
      overlapping_pending_requests.each { |request| request.deny! }
      update!(status: "APPROVED")
    end
  end

  def deny!
    update!(status: "DENIED")
  end

  def overlapping_requests
    cat.cat_rental_requests
      .where("(:id IS NULL) OR (cat_rental_requests.id != :id)", id: self.id)
      .where("(start_date BETWEEN ? AND ? ) OR (end_date BETWEEN ? AND ?)",
      start_date, end_date, start_date, end_date
      )
  end

  def overlapping_approved_requests
    overlapping_requests.where("status='APPROVED'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status='PENDING'")
  end

  def has_no_overlapping_approved_requests
    if overlapping_approved_requests.empty?
      errors[:id] << "has overlapping approved requests."
    end
  end

  def pending?
    status == "PENDING"
  end

  def approved?
    status == "APPROVED"
  end

  def denied?
    status == "DENIED"
  end
end
