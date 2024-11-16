class Question < ApplicationRecord
  has_many :answer_choices, dependent: :destroy
  has_many :question_categories, dependent: :destroy, inverse_of: :question
  has_many :question_sources, dependent: :destroy, inverse_of: :question
  accepts_nested_attributes_for :answer_choices, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question_categories, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :question_sources, reject_if: :all_blank, allow_destroy: true
  validates :text, presence: true
end
