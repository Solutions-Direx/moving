class AddDepartmentToClient < ActiveRecord::Migration
  def change
    add_column :clients, :department, :string
  end
end
