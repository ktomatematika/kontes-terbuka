class AddTimezoneToProvinces < ActiveRecord::Migration
  def change
    add_column :provinces, :timezone, :string
  end
end
