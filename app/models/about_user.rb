class AboutUser < ActiveRecord::Base
    # Associations
    belongs_to :user
    has_attached_file :image, styles: { small: '150x150>' }
  
    # Validations
    validates :name, presence: true
    validates :description, presence: true
    validates_attachment :image, presence: true
    validates_attachment_content_type :image, content_type: ['image/png', 'image/jpeg', 'image/jpg']
end
