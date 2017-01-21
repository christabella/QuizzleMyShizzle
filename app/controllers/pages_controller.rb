require 'csv'
class PagesController < ApplicationController

  def index
  end

  def upload
    CSV.foreach(params[:deck]) do |row|
      Deck.create(params[:name])
    end
  end

end
