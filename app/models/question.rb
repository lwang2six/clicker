class Question < ActiveRecord::Base
  belongs_to :problem_sets
  has_many :answers
  has_many :responses
end
