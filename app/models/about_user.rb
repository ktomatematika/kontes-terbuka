class AboutUser < ActiveRecord::Base
    # Associations
    belongs_to :user
    has_attached_file :image
  
    # Validations
    validates :name, presence: true
    validates :description, presence: true
    validates_attachment :image, presence: true 
    validates_attachment_content_type :image, content_type: ['image/png', 'image/jpeg']
end
