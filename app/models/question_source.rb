class QuestionSource < ApplicationRecord
  belongs_to :question
  belongs_to :source
end
