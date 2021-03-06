require 'espeak'
require 'amatch'
class Deck::CardsController < ApplicationController
  include ESpeak
  include Amatch

  before_action :prepare_deck

  def index
  end

  def show
    @card = find_card
    Speech.new(@card.question).speak
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
      Speech.new("Didn't hear you properly. Try again!").speak
      redirect_to deck_card_path(@deck, params[:id])
    end

    @card = find_card
    sorted = @deck.cards.order("next_repetition DESC")
    index = sorted.index(@card)
    next_id = sorted[index+1].id


    result = results&.first
    if result && check_ans(result.transcript, find_card.answer)
      @card.process_recall_result(5)
      puts result.transcript.inspect
      congratulatory_msg = ["Correct!", "Nice.", "Go get 'em, Tiger!", "Booyah!", "Aww yeah...", "You go, girl!"].sample
      Speech.new(congratulatory_msg).speak
      @url = deck_card_path(@deck, next_id)
      render layout: false
    else

      if result
        @card.process_recall_result(1)
        encouraging_msg = ["Try again!", "Not quite...", "Ahaha... Good one. Almost.", "Close, but no cigar."].sample
        Speech.new(encouraging_msg).speak
      else
        Speech.new("Didn't hear you properly. Try again!").speak
      end
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

  def check_ans(string1, string2)
    puts(string1, string2)
    threshold = 0.5
    val = string1.levenshtein_similar(string2)
    puts val
    return val > threshold
  end

end
