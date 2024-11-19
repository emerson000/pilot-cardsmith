class Category < ApplicationRecord
  # A category can belong to a parent category
  belongs_to :parent, class_name: "Category", optional: true

  # A category can have many subcategories
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy

  has_many :question_categories
  has_many :questions, through: :question_categories

  # Ensure name is present
  validates :name, presence: true
end
