class CreateQuestionSources < ActiveRecord::Migration[7.2]
  def change
    create_table :question_sources do |t|
      t.references :question, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true

      t.timestamps
    end
  end
end
