chabclass Card < ActiveRecord::Base
  include Repetition
  include ESpeak

  belongs_to :deck
  validates :question, presence: true
  validates :answer, presence: true
end
