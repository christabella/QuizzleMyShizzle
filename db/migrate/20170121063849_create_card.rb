class CreateCard < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.text :question
      t.text :answer
      t.decimal :easyness_factor
      t.integer :number_of_repetitions
      t.integer :quality_of_last_recall
      t.datetime :next_repetition
      t.decimal :repetition_interval
      t.datetime :last_studied
    end
  end
end
