require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:manager) { Manager.create(email: 'managertest@gmail.com', password: 'password', password_confirmation: 'password', name: 'ManagerTest')}
  let(:developer) { Developer.create(email: 'devtest@example.com', password: 'password', password_confirmation: 'password', name: 'DevTest')}
  let(:qa) { Qa.create(email: 'QAtest@example.com', name: 'ExampleQATest', password: 'password', password_confirmation: 'password') }

  describe 'GET /index' do
    it 'project index works for Manager!' do
      sign_in manager
      get user_projects_path(user_id: manager.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project index works for Developer!' do
      sign_in developer
      get user_projects_path(user_id: developer.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project index works for QA!' do
      sign_in qa
      get user_projects_path(user_id: qa.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /show' do
    it 'project show works for Manager!' do
      sign_in manager
      pr = manager.projects.create(name: 'project test')
      get user_project_path(user_id: manager.id, id: pr.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project show works for Developer!' do
      sign_in developer
      developer.projects << manager.projects.create(name: 'project test')
      pr = developer.projects.first
      get user_project_path(user_id: developer.id, id: pr.id)
      expect(response).to have_http_status(:ok)
    end
  end
end
