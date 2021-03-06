class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :question_desc
      t.integer :sub_genre_id
      t.boolean :is_multiple, default: false
      t.references :subgenre, foreign_key: true

      t.timestamps
    end
  end
end
