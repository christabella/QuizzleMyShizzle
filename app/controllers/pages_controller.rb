require 'csv'
class PagesController < ApplicationController

  def index
  end

  def upload
    deck = Deck.create(name: deck_name)
    CSV.parse(params[:deck].read) do |row|
      card = Card.new(card_params(row))
      deck.cards << card
      card.reset_spaced_repetition_data
      card.process_recall_result(1)
      card.save
    end
    redirect_to deck_cards_path(deck)
  end

  private

  def deck_name
    params.require(:name)
  end

  def card_params(row)
    {
      question: row[0],
      answer: row[1]
    }
  end

end
