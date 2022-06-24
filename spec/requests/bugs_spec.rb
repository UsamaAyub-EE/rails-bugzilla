require 'rails_helper'

RSpec.describe 'Bugs', type: :request do
  let(:manager) { Manager.create(email: 'managertest@gmail.com', password: 'password', password_confirmation: 'password', name: 'ManagerTest')}
  let(:developer) { Developer.create(email: 'devtest@example.com', password: 'password', password_confirmation: 'password', name: 'DevTest')}
  let(:qa) { Qa.create(email: 'QAtest@example.com', name: 'ExampleQATest', password: 'password', password_confirmation: 'password') }
  let(:project) { manager.projects.create(name: 'project test') }
  let(:bug) { qa.bugs.create(title: 'bug test', description: 'bug test description', kind: 'Bug', stature: 'New', project_id: project.id) }

  describe 'GET /index' do
    it 'bug index does not work for Manager!' do
      sign_in manager
      get user_project_bugs_path(user_id: manager.id, project_id: project.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug index works for Developer!' do
      sign_in developer
      get user_project_bugs_path(user_id: developer.id, project_id: project.id)
      expect(response).to have_http_status(:ok)
    end

    it 'bug index works for QA!' do
      sign_in qa
      get user_project_bugs_path(user_id: qa.id, project_id: project.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /show' do
    it 'bug show does not work for Manager!' do
      sign_in manager
      get user_project_bug_path(user_id: manager.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug show works for Developer if he is in project' do
      sign_in developer
      developer.projects << project
      get user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:ok)
    end

    it 'bug show works for QA!' do
      sign_in qa
      get user_project_bug_path(user_id: qa.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:ok)
    end

    it 'bug show does not work for Developer if he is not in project!' do
      sign_in developer
      get user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /new' do
    it 'bug new does not work for Manager!' do
      sign_in manager
      get new_user_project_bug_path(user_id: manager.id, project_id: project.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug new does not work for Developer!' do
      sign_in developer
      get new_user_project_bug_path(user_id: developer.id, project_id: project.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug new works for QA!' do
      sign_in qa
      get new_user_project_bug_path(user_id: qa.id, project_id: project.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /create' do
    it 'bug create does not work for Manager!' do
      sign_in manager
      post user_project_bugs_path(user_id: manager.id, project_id: project.id), params: { bug: { title: 'Test bug', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug create does not work for Developer!' do
      sign_in developer
      post user_project_bugs_path(user_id: developer.id, project_id: project.id), params: { bug: { title: 'Test bug', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug create works for QA!' do
      sign_in qa
      post user_project_bugs_path(user_id: qa.id, project_id: project.id), params: { bug: { title: 'Test bug', kind: 'Bug', stature: 'New', project_id: project.id, qa_id: qa.id } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'GET /edit' do
    it 'bug edit does not work for Manager!' do
      sign_in manager
      get edit_user_project_bug_path(user_id: manager.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug edit does not work for Developer!' do
      sign_in developer
      get edit_user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug edit works for QA!' do
      sign_in qa
      get edit_user_project_bug_path(user_id: qa.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT /update' do
    it 'bug update does not work for Manager!' do
      sign_in manager
      put user_project_bug_path(user_id: manager.id, project_id: project.id, id: bug.id), params: { bug: { title: 'Test bug update', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug update works for Developer if he is in project!' do
      sign_in developer
      developer.projects << project
      put user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id), params: { bug: { title: 'Test bug update', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:redirect)
    end

    it 'bug update does not work for Developer if he is not in project!' do
      sign_in developer
      put user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id), params: { bug: { title: 'Test bug update', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug update works for QA!' do
      sign_in qa
      put user_project_bug_path(user_id: qa.id, project_id: project.id, id: bug.id), params: { bug: { title: 'Test bug update', kind: 'Bug', stature: 'New' } }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'DELETE /destroy' do
    it 'bug destroy does not work for Manager!' do
      sign_in manager
      delete user_project_bug_path(user_id: manager.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug destroy does not work for Developer!' do
      sign_in developer
      delete user_project_bug_path(user_id: developer.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'bug destroy works for QA!' do
      sign_in qa
      delete user_project_bug_path(user_id: qa.id, project_id: project.id, id: bug.id)
      expect(response).to have_http_status(:redirect)
    end
  end
end
