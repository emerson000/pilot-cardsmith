class AnswerChoiceSerializer < ActiveModel::Serializer
  attributes :id, :text, :is_correct
end
