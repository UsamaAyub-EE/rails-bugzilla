require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:manager) { Manager.create(email: 'managertest@gmail.com', password: 'password', password_confirmation: 'password', name: 'ManagerTest')}
  let(:developer) { Developer.create(email: 'devtest@example.com', password: 'password', password_confirmation: 'password', name: 'DevTest')}
  let(:qa) { Qa.create(email: 'QAtest@example.com', name: 'ExampleQATest', password: 'password', password_confirmation: 'password') }
  let(:project) { manager.projects.create(name: 'project test') }

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
    let(:manager2) { Manager.create(email: 'managertest2@gmail.com', password: 'password', password_confirmation: 'password', name: 'ManagerTest2') }
    let(:project2) { manager2.projects.create(name: 'project test 2') }

    it 'project show works for Manager!' do
      sign_in manager
      get user_project_path(user_id: manager.id, id: project.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project show works for Developer!' do
      sign_in developer
      developer.projects << project
      get user_project_path(user_id: developer.id, id: project.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project show works for QA!' do
      sign_in qa
      get user_project_path(user_id: qa.id, id: project.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project show does not work on projects developer is not added in' do
      sign_in developer
      get user_project_path(user_id: developer.id, id: project2.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'project show does not work on projects manager did not create' do
      sign_in manager
      get user_project_path(user_id: manager.id, id: project2.id)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /new' do
    it 'project new works for Manager!' do
      sign_in manager
      get new_user_project_path(user_id: manager.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project new does not work for Developer!' do
      sign_in developer
      get new_user_project_path(user_id: developer.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'project new does not work for QA!' do
      sign_in qa
      get new_user_project_path(user_id: qa.id)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST /create' do
    it 'project create works for Manager!' do
      sign_in manager
      post user_projects_path(user_id: manager.id), params: { project: { name: 'project test' } }
      expect(response).to have_http_status(:redirect)
    end

    it 'project create does not work for Developer!' do
      sign_in developer
      post user_projects_path(user_id: developer.id), params: { project: { name: 'project test' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'project create does not work for QA!' do
      sign_in qa
      post user_projects_path(user_id: qa.id), params: { project: { name: 'project test' } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'GET /edit' do
    it 'project edit works for Manager!' do
      sign_in manager
      get edit_user_project_path(user_id: manager.id, id: project.id)
      expect(response).to have_http_status(:ok)
    end

    it 'project edit does not work for Developer!' do
      sign_in developer
      get edit_user_project_path(user_id: developer.id, id: project.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'project edit does not work for QA!' do
      sign_in qa
      get edit_user_project_path(user_id: qa.id, id: project.id)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT /update' do
    it 'project update works for Manager!' do
      sign_in manager
      put user_project_path(user_id: manager.id, id: project.id), params: { project: { name: 'project test update' } }
      expect(response).to have_http_status(:redirect)
    end

    it 'project update does not work for Developer!' do
      sign_in developer
      put user_project_path(user_id: developer.id, id: project.id), params: { project: { name: 'project test update' } }
      expect(response).to have_http_status(:forbidden)
    end

    it 'project update does not work for QA!' do
      sign_in qa
      put user_project_path(user_id: qa.id, id: project.id), params: { project: { name: 'project test update' } }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PUT /project_assignment' do
    it 'project assignment works for Manager!' do
      sign_in manager
      put project_assignment_project_path(id: project.id), params: { developer_id: developer.id }
      expect(response).to have_http_status(:redirect)
    end

    it 'project assignment does not work for Developer!' do
      sign_in developer
      put project_assignment_project_path(id: project.id), params: { developer_id: developer.id }
      expect(response).to have_http_status(:forbidden)
    end

    it 'project assignment does not work for QA!' do
      sign_in qa
      put project_assignment_project_path(id: project.id), params: { developer_id: developer.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'DELETE /destroy' do
    it 'project destroy works for Manager!' do
      sign_in manager
      delete user_project_path(user_id: manager.id, id: project.id)
      expect(response).to have_http_status(:redirect)
    end

    it 'project destroy does not work for Developer!' do
      sign_in developer
      delete user_project_path(user_id: developer.id, id: project.id)
      expect(response).to have_http_status(:forbidden)
    end

    it 'project destroy does not work for QA!' do
      sign_in qa
      delete user_project_path(user_id: qa.id, id: project.id)
      expect(response).to have_http_status(:forbidden)
    end
  end
end
