class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :text, :explanation
  has_many :answer_choices
end
