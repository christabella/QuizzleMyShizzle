class CreateDeck < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string :name
    end
  end
end
