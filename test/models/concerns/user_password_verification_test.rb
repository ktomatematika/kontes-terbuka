# frozen_string_literal: true

require 'test_helper'

class UserPasswordVerificationTest < ActiveSupport::TestCase
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
    u1 = create(:user, password: 'qwerty')
    u2 = create(:user, username: 'otheruser', password: 'qwerty')
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

  test 'password is updated' do
    u = create(:user)
    u.update(password: 'qwerqwer234')
    assert u.authenticate('qwerqwer234'), 'Password is not updated.'
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

  test 'get_user function returns user from lowercase username or email' do
    create(:user, username: 'cobaaja', email: 'coba@aja.com')
    assert_not_nil User.get_user('cobaaja')
    assert_not_nil User.get_user('cobaAja')
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

    u1.destroy_if_unverified_without_delay
    u2.destroy_if_unverified_without_delay
    assert_not u1.destroyed?
    assert u2.destroyed?
  end

  test 'wrong_password_process method returns false with minimal tries' do
    u = create(:user, tries: 3)
    assert_not u.wrong_password_process,
               'wrong_password_process returns true with few tries'
    assert_equal u.tries, 4,
                 'wrong_password_process does not increment tries'
  end

  test 'wrong_password_process method returns true when too many tries' do
    u = create(:user, tries: 9)
    assert u.wrong_password_process,
           'wrong_password_process returns true with few tries'
    assert_not_nil u.verification, 'verification is not generated.'
  end
end
