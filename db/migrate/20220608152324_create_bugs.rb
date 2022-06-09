# frozen_string_literal: true

class CreateBugs < ActiveRecord::Migration[5.2]
  def change
    create_table :bugs do |t|
      t.string :title
      t.datetime :deadline
      t.string :kind
      t.string :stature
      t.text :description

      t.belongs_to :developer, index: false, null: true, default: nil
      t.belongs_to :qa, index: true
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
