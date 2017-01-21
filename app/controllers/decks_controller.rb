class DecksController < ApplicationController

  def index
    @decks = Deck.all
  end

  def show
    @deck = find_deck
  end

  private

  def find_deck
    Deck.find(params[:id])
  end

end
