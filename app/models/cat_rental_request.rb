class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: %w(PENDING APPROVED DENIED)

  belongs_to :cat

  after_initialize do |request|
    request.status ||= "PENDING"
  end

  def approve!
  end


  def overlapping_requests
    cat.cat_rental_requests
      .where("(:id IS NULL) OR (cat_rental_requests.id != :id)",
      id: self.id
      )
      .where("(start_date BETWEEN ? AND ? ) OR (end_date BETWEEN ? AND ?)", start_date, end_date, start_date, end_date)

  end

  def overlapping_approved_requests
    overlapping_requests("WHERE status='APPROVED'")
  end
end
