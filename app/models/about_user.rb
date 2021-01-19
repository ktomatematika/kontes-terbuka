class AboutUser < ActiveRecord::Base
    # Associations
    belongs_to :user

    # Validations
    validates :name, presence: true
    validates :description, presence: true
end
