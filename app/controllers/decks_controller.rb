class DecksController < ApplicationController

  def index
    @decks = Deck.all
    require 'googleauth'
    scopes =  ['https://www.googleapis.com/auth/cloud-platform']
    authorization = Google::Auth.get_application_default(scopes)


    require "google/cloud/speech"
    
    speech = Google::Cloud::Speech.new
    
    audio = speech.audio "brooklyn.wav",
                         encoding: :linear16, sample_rate: 16000

    results = audio.recognize
    
    result = results.first
    @result = result.transcript #=> "how old is the Brooklyn Bridge"
    result.confidence #=> 0.9826789498329163
    ##### ASYNC ONE

    # job = audio.recognize_job
    
    # job.done? #=> false
    # job.reload!
    # job.done? #=> true
    # puts job
    # results = job.results
    
    # result = results.first
    # result.transcript #=> "how old is the Brooklyn Bridge"
    # result.confidence #=> 0.9826789498329163
  end

end
