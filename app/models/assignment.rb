class Assignment < ApplicationRecord
  belongs_to :developer
  belongs_to :project
end
