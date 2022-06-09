# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Manager.create({ email: 'manager@gmail.com', password: 'password', password_confirmation: 'password',
                 name: 'Manager' })
Manager.create({ email: 'manager@example.com', password: 'password', password_confirmation: 'password',
                 name: 'ExampleManager' })
Developer.new({ email: 'usama@gmail.com', password: 'password', password_confirmation: 'password',
                name: 'Usama' }).save
Developer.new({ email: 'dev@example.com', password: 'password', password_confirmation: 'password',
                name: 'Dev' }).save
Qa.create({ email: 'QA@gmail.com', name: 'usamaQA', password: 'password',
            password_confirmation: 'password' })
Qa.create({ email: 'QA@example.com', name: 'ExampleQA', password: 'password',
            password_confirmation: 'password' })
mn = Manager.first
mn.projects.create(name: 'project 1')
q1 = Qa.first
q1.bugs.create(title: 'P1 Bug', kind: 'Bug', stature: 'New', project_id: 1, description: 'This is a new bug')
q1.bugs.create(title: 'P1 Bug 2', kind: 'Bug', stature: 'New', project_id: 1, developer_id: 1,
               description: 'This is an old bug')
dv = Developer.first
dv.projects << Project.first
