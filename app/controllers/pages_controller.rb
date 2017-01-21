require 'csv'
class PagesController < ApplicationController

  def index
  end

  def upload
    deck = Deck.create(name: deck_name)
    CSV.parse(params[:deck].read) do |row|
      deck.cards << Card.create(card_params(row))
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
