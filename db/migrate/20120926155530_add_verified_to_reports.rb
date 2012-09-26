class AddVerifiedToReports < ActiveRecord::Migration
  def change
    add_column :reports, :verified, :boolean, default: false
    add_column :reports, :verified_at, :datetime
    add_column :reports, :verificator_id, :integer 
  end
end
