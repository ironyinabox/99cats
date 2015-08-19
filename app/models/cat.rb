class Cat < ActiveRecord::Base
  validates :birth_date, :color, :name, :sex, :user_id, presence: true
  validates :sex, inclusion: %w(M F)
  validates :color, inclusion: %w(orange black white gray combo)
  validates :owner, presence: true

  has_many :cat_rental_requests, dependent: :destroy
  belongs_to :owner,
  class_name: "User",
  foreign_key: :user_id

  def age
    # (Date.today.year - birth_date.year)
    now = Time.now.utc.to_date
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def age_in_years
    age.year
  end
end
