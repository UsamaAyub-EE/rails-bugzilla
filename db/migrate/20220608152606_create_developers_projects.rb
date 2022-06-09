# frozen_string_literal: true

class CreateDevelopersProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.belongs_to :manager, index: true

      t.timestamps
    end
    create_table :projects_users, id: false do |t|
      t.belongs_to :developer, index: true
      t.belongs_to :project, index: true

      t.timestamps
    end
    add_index :projects, :name, unique: true
  end
end
