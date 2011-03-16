class Answer < ActiveRecord::Base
  belongs_to :questions
  has_many :responses
end
