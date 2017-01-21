class Deck::CardsController < ApplicationController

  before_action :prepare_deck

  def index
  end

  def show
    @card = find_card
  end

  def speech_command
  end

  private

  def prepare_deck
    @deck = Deck.find(params[:deck_id])
  end

  def find_card
    @deck.cards.find(params[:id])
  end

end
