class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.text :text
      t.text :explanation

      t.timestamps
    end
  end
end
