# frozen_string_literal: true

require 'test_helper'

class CreateNewUserTest < ActionDispatch::IntegrationTest
  test 'create new user, verify and login' do
    create(:contest, name: 'Kontes Coba', start: 30_000, ends: 50_000,
                     result: 80_000, feedback: 120_000)

    visit '/'
    assert page.has_content?('KTO Matematika'), 'Landing page does not ' \
      'have KTO Matematika.'
    assert page.has_content?('Kontes Coba'), 'Landing page does not ' \
      'have the next contest.'

    masuk = find_link('Masuk', class: 'btn', match: :first)
    daftar = find_link('Daftar', class: 'btn', match: :first)
    assert_not_nil masuk, 'Landing page does not have "Masuk" button.'
    assert_not_nil daftar, 'Landing page does not have "Daftar" button.'

    daftar.click
    assert page.has_current_path?('/users/sign'),
           'Clicking "Daftar" does not redirect to registration form.'
    assert page.has_selector?('form'), 'Form is not there.'

    within('#register') do
      fill_in 'Username', with: 'cobaasalaja'
      fill_in 'Alamat email', with: 'a.b@gmail.com'
      fill_in 'Password', with: 'cobaasal'
      fill_in 'Ulangi password', with: 'cobaasal'
      fill_in 'Nama lengkap', with: 'Halo Halo'
      select 'Banten', from: 'user_province_id'
      select 'Kelas 9', from: 'user_status_id'
      fill_in 'Sekolah/institusi', with: 'Sekolah Keren'
      check 'kebijakan privasi'
      check 'OSN'

      click_on 'Daftar'
    end

    assert page.has_current_path?('/'), 'Successfully registering does not ' \
      'redirect to root.'
    assert page.has_content?('Registrasi berhasil!'), 'Successfully ' \
      'registering does not show flash.'

    assert_equal User.count, 1, 'User is not created.'
    u = User.take
    assert_equal u.username, 'cobaasalaja', 'Username is not right.'
    assert_equal u.email, 'a.b@gmail.com', 'Email is not right.'
    assert u.authenticate('cobaasal'), 'Password is not right.'
    assert_equal u.fullname, 'Halo Halo', 'Fullname is not right.'
    assert_equal u.province, Province.find_by(name: 'Banten'),
                 'Province is not right.'
    assert_equal u.status, Status.find_by(name: 'Kelas 9'),
                 'Status is not right.'
    assert_equal u.school, 'Sekolah Keren', 'School is not right.'
    assert u.has_role?(:veteran), 'User who ticks OSN is not veteran.'

    assert_not u.enabled, 'User is enabled without confirmation email!'

    visit "/users/verify/#{u.verification}"
    assert page.has_current_path?('/users/sign')

    within('#login') do
      fill_in 'username', with: 'cobaasalaja'
      fill_in 'password', with: 'cobaasal'
      click_on 'Masuk', class: 'btn'
    end

    assert page.has_current_path?('/home'),
           'Logging in does not redirect to home page.'
    assert page.has_content?('Halo, cobaasalaja'), 'Home page does not ' \
    'display greeting.'
  end
end
