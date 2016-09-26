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
#  index_users_on_auth_token    (auth_token) UNIQUE
#  index_users_on_color_id      (color_id)
#  index_users_on_email         (email) UNIQUE
#  index_users_on_province_id   (province_id)
#  index_users_on_status_id     (status_id)
#  index_users_on_username      (username) UNIQUE
#  index_users_on_verification  (verification) UNIQUE
#
# Foreign Keys
#
#  fk_rails_560da4bd54  (province_id => provinces.id) ON DELETE => nullify
#  fk_rails_87f75b7957  (color_id => colors.id) ON DELETE => nullify
#  fk_rails_ce4a327a04  (status_id => statuses.id) ON DELETE => nullify
#
# rubocop:enable Metrics/LineLength

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
    prov = create(:province, timezone: 'WIT')
    assert_equal create(:user, province: prov).timezone, 'WIT',
                 'User timezone is not defaulted to the province.'
  end

  test 'timezone defaults to WIB when province is nil' do
    assert_equal create(:user, province: nil).timezone, 'WIB',
                 'User timezone default is not WIB on nil province.'
  end

  test 'user is not enabled by default' do
    assert_not create(:user).enabled, 'User is enabled on creation.'
  end

  test 'user tries start with 0' do
    assert create(:user).tries.zero?, 'User does not start with zero tries.'
  end

  test 'nullify attributes on delete' do
    u = create(:user)
    u.province.destroy
    assert_nil u.province, 'Province is not nullified on delete.'
    u.color.destroy
    assert_nil u.color, 'Color is not nullified on delete.'
    u.status.destroy
    assert_nil u.status, 'Status is not nullified on delete.'
  end

  test 'password is encrypted and cleared before save' do
    password = 'asdfasdf'
    u = create(:user, password: 'asdfasdf', password_confirmation: password)
    assert_nil u.password, 'Password is not cleared.'
    assert_not_equal u.hashed_password, password,
                     'Password is stored unencrypted!'
  end

  test 'password needs confirmation' do
    assert_not build(:user, password: 'qwerty',
                            password_confirmation: '').save,
               'Passwords without confirmation can be saved.'
    assert_not build(:user, password: 'qwerty',
                            password_confirmation: 'azerty').save,
               'Passwords that does not match can be saved.'
  end

  test 'salt is sufficiently strong' do
    u = create(:user)
    s = u.salt
    assert s.length >= 20, 'Salt length is < 20.'
    assert_no_match(/\A[a-z]*\z$/, s, 'Salt is all lowercase.')
    assert_no_match(/\A[A-Z]*\z$/, s, 'Salt is all uppercase.')
    assert_no_match(/\A[0-9]*\z$/, s, 'Salt is all numbers.')
  end

  test 'hashed password starts with salt' do
    u = create(:user)
    assert u.hashed_password.start_with?(u.salt),
           'Hashed password does not start with salt.'
  end

  test 'salt actually works' do
    u1 = create(:user, pass: 'qwerty')
    u2 = create(:user, username: 'otheruser', pass: 'qwerty')
    assert_not_equal u1.hashed_password, u2.hashed_password,
                     'Password can be rainbow tabled!'
  end

  test 'hashed password is strong' do
    u = create(:user)
    p = u.hashed_password
    assert p.length >= 50, 'Hashed passowrd length is < 50'
    assert_no_match(/\A[a-z]*\z$/, p, 'Hashed pass is all lowercase.')
    assert_no_match(/\A[A-Z]*\z$/, p, 'Hashed pass is all uppercase.')
    assert_no_match(/\A[0-9]*\z$/, p, 'Hashed pass is all numbers.')
  end

  test 'auth token and verification are generated' do
    u = create(:user)
    assert_not_empty u.auth_token, 'Auth token is empty.'
    assert_not_empty u.verification, 'Verification is empty.'
  end

  test 'auth token and verification are unique' do
    25.times { |i| create(:user, username: 'cobaaja' + i.to_s) }
    auth_tokens = User.pluck(:auth_token)
    verifications = User.pluck(:verification)

    assert_equal auth_tokens.uniq.length, auth_tokens.length,
                 'There exist duplicate auth tokens!'
    assert_equal verifications.uniq.length, verifications.length,
                 'There exist duplicate verifications!'
  end

  test 'user associations' do
    assert_equal User.reflect_on_association(:province).macro, :belongs_to,
                 'User does not belong to province.'
    assert_equal User.reflect_on_association(:color).macro, :belongs_to,
                 'User does not belong to color.'
    assert_equal User.reflect_on_association(:status).macro, :belongs_to,
                 'User does not belong to status.'
    assert_equal User.reflect_on_association(:user_contests).macro, :has_many,
                 'User has many user contests is false.'
    assert_equal User.reflect_on_association(:user_awards).macro, :has_many,
                 'User has many user awards is false.'
    assert_equal User.reflect_on_association(:temporary_markings).macro,
                 :has_many,
                 'User has many temporary markings contests is false.'
    assert_equal User.reflect_on_association(:user_notifications).macro,
                 :has_many,
                 'User has many user notifications contests is false.'
    assert_equal User.reflect_on_association(:point_transactions).macro,
                 :has_many,
                 'User has many point transactions contests is false.'
  end

  test 'tries need to be >= 0' do
    assert_not build(:user, tries: -2).save,
               'User with negative tries can be saved.'
  end

  test 'terms of service needs to be accepted' do
    assert_not build(:user, terms_of_service: '0').save,
               'User that does not accept terms of service can be registered.'
  end

  test 'user is displayed by its username' do
    assert_equal create(:user, username: 'qwerty').to_s, 'qwerty'
  end

  test 'in params, user is shown as its ID followed by its username' do
    u1 = create(:user, username: 'qwerty')
    u2 = create(:user, username: 'ASDFGH')
    u3 = create(:user, username: 'ZxCvBnM123')

    assert_equal u1.to_param, "#{u1.id}-qwerty"
    assert_equal u2.to_param, "#{u2.id}-asdfgh"
    assert_equal u3.to_param, "#{u3.id}-zxcvbnm123"
  end

  test 'get_user function returns user from either username or email' do
    create(:user, username: 'cobaaja', email: 'coba@aja.com')
    assert_not_nil User.get_user('cobaaja')
    assert_not_nil User.get_user('coba@aja.com')
  end

  test 'authenticate works' do
    u = create(:user, password: 'halohalo', password_confirmation: 'halohalo')
    assert u.authenticate('halohalo')
  end

  test 'reset password works' do
    u = create(:user)
    u.reset_password
    assert_not_nil u.verification
  end

  test 'user is destroyed if not verified' do
    u1 = create(:user, username: 'qwerqwer')
    u1.enable
    u2 = create(:user, username: 'zxcvzxcv')

    u1.destroy_if_unverified
    u2.destroy_if_unverified
    assert_not u1.destroyed?
    assert u2.destroyed?
  end

  test 'user becomes veteran if osn is checked' do
    assert create(:user, osn: '1').has_role?(:veteran)
  end
end
