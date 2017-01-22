class ChangeNumberRepetition < ActiveRecord::Migration
  def change
  	rename_column :cards, :number_of_repetitions, :number_repetitions
  end
end
