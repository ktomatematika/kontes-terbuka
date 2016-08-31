# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string
#  email           :string
#  hashed_password :string
#  fullname        :string
#  school          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  salt            :string
#  auth_token      :string
#  province_id     :integer
#  status_id       :integer
#  color_id        :integer          default(1)
#  timezone        :string           default("WIB")
#  verification    :string
#  enabled         :boolean          default(FALSE)
#  tries           :integer          default(0)
#
# Indexes
#
#  idx_mv_users_email_uniq     (email) UNIQUE
#  idx_mv_users_username_uniq  (username) UNIQUE
#  index_users_on_color_id     (color_id)
#  index_users_on_province_id  (province_id)
#  index_users_on_status_id    (status_id)
#
# Foreign Keys
#
#  fk_rails_560da4bd54  (province_id => provinces.id)
#  fk_rails_87f75b7957  (color_id => colors.id)
#  fk_rails_ce4a327a04  (status_id => statuses.id)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  prov = Province.first
  stat = Status.first
  color = Color.first
  u = User.new(username: 'asdfasdf', password: 'halohalo',
               password_confirmation: 'halohalo',
               email: 'test@gmail.com', fullname: 'Nama Lengkap',
               province: prov, status: stat, school: 'SMAK 1',
               color: color, terms_of_service: '1')

  test 'user that fulfills all criteria is OK' do
    user = u.clone
    assert user.save, 'User is not saved'
    user.destroy
  end

  test 'username exists' do
    p = u.clone
    p.username = nil
    assert_not p.save, 'User without username is saved'
  end

  test 'username is unique' do
    p = u.clone
    # user with duplicate emails cannot be saved. Test the right thing
    p.email = '7744han@gmail.com'
    p.save
    assert_not u.save, 'User with duplicate usernames can be saved'
    p.destroy
  end

  test 'username should have 6 to 20 characters' do
    four = u.clone
    four.username = 'asdf'
    assert_not four.save, 'User with 4 chars can be saved'
    thirty = u.clone
    thirty.username = 'asdfgasdfgasdfgasdfgasdfgasdfg'
    assert_not thirty.save, 'User with 30 chars can be saved'
  end

  test 'username should be alphanumeric' do
    with_space = u.clone
    with_space.username = 'asdfg '
    with_space2 = with_space.clone
    with_space2.username = ' halo halo'
    with_space3 = with_space2.clone
    with_space3.username = '        '

    assert_not with_space.save, 'User with a space can be saved'
    assert_not with_space.save, 'User with a space can be saved'
    assert_not with_space.save, 'User with a space can be saved'

    with_symbols = u.clone
    with_symbols.username = "awiweor\#@#"
    with_symbols2 = with_symbols.clone
    with_symbols2.username = '234234_cd7'
    with_symbols3 = with_symbols.clone
    with_symbols3.username = '-_--_-'

    assert_not with_symbols.save, 'Usernames with a symbol can be saved'
    assert_not with_symbols2.save, 'Usernames with a symbol can be saved'
    assert_not with_symbols3.save, 'Usernames with a symbol can be saved'
  end

  test 'email should exist' do
    no_email = u.clone
    no_email.email = nil
    assert_not no_email.save, 'User without email is able to be saved'
  end

  test 'email should be unique' do
    clone_of_u = u.clone
    clone_of_u.username = 'halohlaoh'
    clone_of_u.save
    clone_of_u2 = clone_of_u.clone
    # user with duplicate usernames cannot be saved. Test the right thing
    clone_of_u2.username = 'Mulpinmulpin'
    assert_not clone_of_u2.save, 'User with duplicate email can be saved'
    clone_of_u.destroy
  end

  test 'email should be in email format' do
    test = u.clone
    test.email = 'a@b.com'
    test2 = test.clone
    test2.email = 'a@u.nus.edu'
    test3 = test2.clone
    test3.email = 'asdf_g@gmail.com'
    test4 = test3.clone
    test4.email = 'abc.def@yahoo.co.id'
    test5 = test4.clone
    test5.email = 'ab_cd_ef_gh.qwer@comp.nus.edu.sg'

    assert test.save, 'a@b.com cannot be saved.'
    test.destroy
    assert test2.save, 'a@u.nus.edu cannot be saved.'
    test2.destroy
    assert test3.save, 'asdf_g@gmail.com cannot be saved.'
    test3.destroy
    assert test4.save, 'abc.def@yahoo.co.id cannot be saved.'
    test4.destroy
    assert test5.save, 'ab_cd_ef_gh.qwer@comp.nus.edu.sg cannot be saved.'
    test5.destroy

    false_email = u.clone
    false_email.email = 'ab cd@email.com'
    assert_not false_email.email, 'A invalid email can be saved.'
  end
end
