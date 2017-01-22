class Deck::CardsController < ApplicationController
  include ::ESpeak

  before_action :prepare_deck

  def index
  end

  def show
    @card = find_card
    speech = Speech.new("Hello!")
    speech.speak # invokes espeak
    respond_to do |format|
        format.js {render layout: false}
    end
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

    rescue Google::Cloud::UnavailableError
      redirect_to deck_card_path(@deck, params[:id])
    end

    results = audio.recognize
    result = results.first
    puts result.transcript.inspect
    @path = deck_card_path(@deck, next_card_id)
    if result&.transcript.downcase == find_card.question.downcase
      respond_to do |format|
        format.js {render layout: false}
      end
      puts "correct answer"
    else
      redirect_to deck_card_path(@deck, params[:id])
    end

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
