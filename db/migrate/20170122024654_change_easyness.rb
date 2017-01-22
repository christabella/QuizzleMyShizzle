class ChangeEasyness < ActiveRecord::Migration
  def change
  	rename_column :cards, :easyness_factor, :easiness_factor
  end
end
