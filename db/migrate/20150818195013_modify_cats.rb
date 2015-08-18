class ModifyCats < ActiveRecord::Migration
  def change
    add_column(:cats, :created_at, :datetime)
    add_column(:cats, :updated_at, :datetime)
  end
end
