class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.string :author
      t.text :body

      t.timestamps
    end
  end
end
