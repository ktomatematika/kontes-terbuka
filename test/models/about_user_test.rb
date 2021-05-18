require 'test_helper'

class AboutUserTest < ActiveSupport::TestCase
  test 'about user should save' do
    assert build(:about_user).save, 'about user cannot be saved'
  end

  test 'about user associations' do 
    assert_equal AboutUser.reflect_on_association(:user).macro, :belongs_to,
      'about user relation is not belongs to user.'
  end

  test 'attachments' do 
    about_user = build(:about_user, image: PNG)
    assert about_user.save, 'About user image cannot be saved'
  end
end
