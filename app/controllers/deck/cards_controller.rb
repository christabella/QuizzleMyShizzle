require 'espeak'
require 'similar_text'
class Deck::CardsController < ApplicationController
  include ESpeak

  before_action :prepare_deck

  def index
  end

  def show
    @card = find_card
    Speech.new("What is the capital of #{@card.question}").speak
  end

  def speech_command
    wavfile = params[:file]
    require 'googleauth'
    scopes =  ['https://www.googleapis.com/auth/cloud-platform']
    authorization = Google::Auth.get_application_default(scopes)

    require "google/cloud/speech"

    speech = Google::Cloud::Speech.new

    tmp = File.open('testing.wav', 'wb+')
    tmp.write(wavfile.read)

    begin
      audio = speech.audio 'testing.wav',
                         encoding: :linear16, sample_rate: 44100
      results = audio.recognize
    rescue Google::Cloud::Error
      redirect_to deck_card_path(@deck, params[:id])
    end

    result = results.first

    if result && result.transcript.downcase.similar(find_card.answer.downcase) > 0.6
      puts result.transcript.inspect
      puts result.transcript.downcase.similar(find_card.answer.downcase)
      @url = deck_card_path(@deck, next_card_id)
      render layout: false
    else
      redirect_to deck_card_path(@deck, params[:id]) end

  end

  private

  def prepare_deck
    @deck = Deck.find(params[:deck_id])
  end

  def find_card
    @deck.cards.find(params[:id])
  end

  def next_card_id
    params[:id].to_i + 1
  end

end
