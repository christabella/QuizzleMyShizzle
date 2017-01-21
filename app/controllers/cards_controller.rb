class CardsController < ApplicationController
  def index
    require "google/cloud/speech"
    
    speech = Google::Cloud::Speech.new
    
    audio = speech.audio "hacknroll.m4a",
                         encoding: :m4a, sample_rate: 16000
    job = audio.recognize_job
    
    job.done? #=> false
    job.reload!
    job.done? #=> true
    results = job.results
    
    result = results.first
    @result = result.transcript #=> "how old is the Brooklyn Bridge"
    result.confidence #=> 0.9826789498329163    
  end
end