require 'rails_helper'

RSpec.describe Bug, type: :model do
  let(:qa) { Qa.create(email: 'QAtest@example.com', name: 'ExampleQATest', password: 'password', password_confirmation: 'password') }
  let(:manager) { Manager.create(email: 'managertest@gmail.com', password: 'password', password_confirmation: 'password', name: 'ManagerTest')}
  let(:pr) { manager.projects.create(name: 'project test') }

  subject {
    described_class.new(title: 'Valid Bug',
                        description: 'Lorem ipsum',
                        kind: 'Bug',
                        stature: 'New',
                        project_id: pr.id,
                        qa_id: qa.id)
  }

  describe 'Associations' do
    it { should belong_to(:qa).without_validating_presence }
    it { should belong_to(:project).without_validating_presence }
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'is not valid without title' do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without status' do
    subject.stature = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid without type' do
    subject.kind = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid with invalid status' do
    subject.stature = 'Some'
    expect(subject).to_not be_valid
  end

  it 'is not valid with invalid type' do
    subject.kind = 'Ended'
    expect(subject).to_not be_valid
  end

  it 'is not valid with a past deadline' do
    subject.deadline = '2012-12-13 12:50'.to_datetime
    expect(subject).to_not be_valid
  end

end
