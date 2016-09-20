# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  hashed_password :string           not null
#  fullname        :string           not null
#  school          :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  salt            :string           not null
#  auth_token      :string           not null
#  province_id     :integer
#  status_id       :integer
#  color_id        :integer          default(1), not null
#  timezone        :string           default("WIB"), not null
#  verification    :string
#  enabled         :boolean          default(FALSE), not null
#  tries           :integer          default(0), not null
#
# Indexes
#
#  idx_mv_users_auth_token_uniq    (auth_token) UNIQUE
#  idx_mv_users_email_uniq         (email) UNIQUE
#  idx_mv_users_username_uniq      (username) UNIQUE
#  idx_mv_users_verification_uniq  (verification) UNIQUE
#  index_users_on_color_id         (color_id)
#  index_users_on_province_id      (province_id)
#  index_users_on_status_id        (status_id)
#
# Foreign Keys
#
#  fk_rails_560da4bd54  (province_id => provinces.id) ON DELETE => nullify
#  fk_rails_87f75b7957  (color_id => colors.id) ON DELETE => nullify
#  fk_rails_ce4a327a04  (status_id => statuses.id) ON DELETE => nullify
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user that fulfills all criteria is OK' do
    assert build(:user).save, 'User is not saved'
  end

  test 'username exists' do
    assert_not build(:user, username: nil).save,
               'User without username is saved'
  end

  test 'username is unique' do
    create(:user)
    assert_not build(:user, email: 'other@a.com').save,
               'User with duplicate usernames can be saved'
  end

  test 'username should have 6 to 20 characters' do
    25.times.each do |i|
      unless i >= 6 && i <= 20
        assert_not build(:user, username: 'a' * i).save,
                   "User with #{i} chars can be saved"
      end
    end
  end

  test 'username should be alphanumeric' do
    assert_not build(:user, username: 'asdfg ').save,
               'User with a space can be saved'
    assert_not build(:user, username: ' halo halo').save,
               'User with a space can be saved'
    assert_not build(:user, username: '        ').save,
               'User with a space can be saved'
    assert_not build(:user, username: 'aw\#@#').save,
               'Usernames with a symbol can be saved'
    assert_not build(:user, username: '234234_cd7').save,
               'Usernames with a symbol can be saved'
    assert_not build(:user, username: '-_--_-').save,
               'Usernames with a symbol can be saved'
  end

  test 'email should exist' do
    assert_not build(:user, email: nil).save,
               'User without email is able to be saved'
  end

  test 'email should be unique' do
    create(:user, email: 'a@b.com')
    assert_not build(:user, username: 'hahahaha', email: 'a@b.com').save,
               'User with duplicate email can be saved'
  end

  test 'email should have one @' do
    assert build(:user, username: 'asdfgh', email: 'a@b.com').save,
           'a@b.com cannot be saved.'
    assert build(:user, username: 'ghasdf', email: 'a@u.nus.edu').save,
           'a@u.nus.edu cannot be saved.'
    assert build(:user, username: 'asdfqw', email: 'ab_cd_ef.gh@a.b.c.d').save,
           'ab_cd_ef.gh@a.b.c.d cannot be saved.'

    assert_not build(:user, email: 'a@b@c.com').save, 'a@b@c.com can be saved.'
    assert_not build(:user, email: 'abc.com').save, 'abc.com can be saved.'
  end

  test 'full name should exist' do
    assert_not build(:user, fullname: nil).save,
      'User with no full name can be saved.'
  end

  test 'school should exist' do
    assert_not build(:user, school: nil).save,
      'User with no school can be saved.'
  end

  test 'timezone follows province' do
    prov = create(:province, timezone: 'ABC')
    assert create(:user, province: prov).timezone == 'ABC',
      'User timezone is not defaulted to the province.'
  end

  test 'timezone defaults to WIB' do
    assert create(:user).timezone == 'WIB',
      'User timezone default is not WIB.'
  end

  test 'user is not enabled by default' do
    assert_not create(:user).enabled,
      'User is enabled on creation.'
  end

  test 'user tries start with 0' do
    assert_not create(:user).tries == 0,
      'User does not start with zero tries.'
  end
end
