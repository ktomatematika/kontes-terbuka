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
  prov = Province.first
  stat = Status.first
  color = Color.first
  u = User.new(username: 'asdfasdf', password: 'halohalo',
               password_confirmation: 'halohalo', email: 'test@gmail.com',
               fullname: 'Nama Lengkap', province: prov, status: stat,
               school: 'SMAK 1', color: color, terms_of_service: '1')

  test 'user that fulfills all criteria is OK' do
    user = u.dup
    assert user.save, 'User is not saved'
    user.destroy
  end

  test 'username exists' do
    p = u.dup
    p.username = nil
    assert_not p.save, 'User without username is saved'
  end

  test 'username is unique' do
    p = u.dup
    p2 = p.dup
    # user with duplicate emails cannot be saved. Test the right thing
    p.email = '7744han@gmail.com'
    p.save
    assert_not p2.save, 'User with duplicate usernames can be saved'
    p.destroy
  end

  test 'username should have 6 to 20 characters' do
    four = u.dup
    four.username = 'asdf'
    assert_not four.save, 'User with 4 chars can be saved'
    thirty = u.dup
    thirty.username = 'asdfgasdfgasdfgasdfgasdfgasdfg'
    assert_not thirty.save, 'User with 30 chars can be saved'
  end

  test 'username should be alphanumeric' do
    with_space = u.dup
    with_space.username = 'asdfg '
    with_space2 = with_space.dup
    with_space2.username = ' halo halo'
    with_space3 = with_space2.dup
    with_space3.username = '        '

    assert_not with_space.save, 'User with a space can be saved'
    assert_not with_space2.save, 'User with a space can be saved'
    assert_not with_space3.save, 'User with a space can be saved'

    with_symbols = u.dup
    with_symbols.username = "awiweor\#@#"
    with_symbols2 = with_symbols.dup
    with_symbols2.username = '234234_cd7'
    with_symbols3 = with_symbols.dup
    with_symbols3.username = '-_--_-'

    assert_not with_symbols.save, 'Usernames with a symbol can be saved'
    assert_not with_symbols2.save, 'Usernames with a symbol can be saved'
    assert_not with_symbols3.save, 'Usernames with a symbol can be saved'
  end

  test 'email should exist' do
    no_email = u.dup
    no_email.email = nil
    assert_not no_email.save, 'User without email is able to be saved'
  end

  test 'email should be unique' do
    p = u.dup
    p.username = 'halohlaoh'
    p.save
    p2 = p.dup
    # user with duplicate usernames cannot be saved. Test the right thing
    p2.username = 'Mulpinmulpin'
    assert_not p2.save, 'User with duplicate email can be saved'
    p.destroy
  end

  test 'email should have one @' do
    p = u.dup
    p.email = 'a@b.com'
    p2 = p.dup
    p2.email = 'a@u.nus.edu'
    p3 = p2.dup
    p3.email = 'asdf_g@gmail.com'
    p4 = p3.dup
    p4.email = 'abc.def@yahoo.co.id'
    p5 = p4.dup
    p5.email = 'ab_cd_ef_gh.qwer@comp.nus.edu.sg'

    assert p.save, 'a@b.com cannot be saved.'
    p.destroy
    assert p2.save, 'a@u.nus.edu cannot be saved.'
    p2.destroy
    assert p3.save, 'asdf_g@gmail.com cannot be saved.'
    p3.destroy
    assert p4.save, 'abc.def@yahoo.co.id cannot be saved.'
    p4.destroy
    assert p5.save, 'ab_cd_ef_gh.qwer@comp.nus.edu.sg cannot be saved.'
    p5.destroy

    p6 = u.dup
    p6.email = 'abcd@x@email.com'
    assert_not p6.email, 'abcd@x@email.com can be saved.'
    p6.destroy
    p7 = u.dup
    p7.email = 'abcdxemail.com'
    assert_not p7.email, 'abcdxemail.com can be saved.'
    p7.destroy
  end
end
