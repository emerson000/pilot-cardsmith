class Category < ApplicationRecord
  # A category can belong to a parent category
  belongs_to :parent, class_name: "Category", optional: true

  # A category can have many subcategories
  has_many :subcategories, class_name: "Category", foreign_key: "parent_id", dependent: :destroy

  has_many :question_categories
  has_many :questions, through: :question_categories

  # Ensure name is present
  validates :name, presence: true

  def all_questions
    Question.joins(:question_categories).where(question_categories: { category_id: all_subcategory_ids })
  end

  def all_subcategory_ids
    [ id ] + subcategories.flat_map(&:all_subcategory_ids)
  end

  def name_with_indentation(level = 0)
    "#{'&nbsp;' * (level * 4)}#{name}".html_safe
  end

  def self.all_with_indentation(categories = Category.where(parent_id: nil), level = 0)
    categories.flat_map do |category|
      [ [ category.name_with_indentation(level), category.id ] ] + all_with_indentation(category.subcategories, level + 1)
    end
  end
end
