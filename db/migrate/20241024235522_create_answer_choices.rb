class CreateAnswerChoices < ActiveRecord::Migration[7.2]
  def change
    create_table :answer_choices do |t|
      t.string :text
      t.boolean :is_correct
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
