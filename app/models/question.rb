class Question < ApplicationRecord
  has_many :answer_choices, dependent: :destroy
  accepts_nested_attributes_for :answer_choices, allow_destroy: true
  validates :text, presence: true
end
