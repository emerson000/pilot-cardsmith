class CreateQuestionCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :question_categories do |t|
      t.references :question, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
