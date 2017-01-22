chabclass Card < ActiveRecord::Base
  include Repetition

  belongs_to :deck
  validates :question, presence: true
  validates :answer, presence: true
end
