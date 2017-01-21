class Deck::CardsController < ApplicationController

  before_action :prepare_deck

  def index
  end

  def show
    @card = find_card
  end

  def speech_command
    wavfile = params[:file]
    raise wavfile.inspect
    require 'googleauth'
    scopes =  ['https://www.googleapis.com/auth/cloud-platform']
    authorization = Google::Auth.get_application_default(scopes)


    require "google/cloud/speech"
    
    speech = Google::Cloud::Speech.new
    
    audio = speech.audio wavfile,
                         encoding: :linear16, sample_rate: 16000

    results = audio.recognize
    
    result = results.first
    puts result.transcript #=> "how old is the Brooklyn Bridge"
    result.confidence #=> 0.9826789498329163


  end

  private

  def prepare_deck
    @deck = Deck.find(params[:deck_id])
  end

  def find_card
    @deck.cards.find(params[:id])
  end

end
