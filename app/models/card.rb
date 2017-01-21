class Card < ActiveRecord::Base
  include Repetition

  validates :question, presence: true
  validates :answer, presence: true
end
