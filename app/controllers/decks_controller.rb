class DecksController < ApplicationController

  def index
    @decks = Deck.all
  end

  def show
    @deck = find_deck
    # raise ENV["GOOGLE_APPLICATION_CREDENTIALS"].inspect

  end

  private

  def find_deck
    Deck.find(params[:id])
  end

end
