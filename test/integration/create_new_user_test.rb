require 'test_helper'

class CreateNewUserTest < ActionDispatch::IntegrationTest
  test 'creates new user' do
    visit '/'
    assert page.has_content?('KTO Matematika'), 'Landing page does not ' \
      'have KTO Matematika.'

    masuk = find_link('Masuk', class: 'btn', match: :first)
    daftar = find_link('Daftar', class: 'btn', match: :first)
    assert_not_nil masuk, 'Landing page does not have "Masuk" button.'
    assert_not_nil daftar, 'Landing page does not have "Daftar" button.'

    daftar.click
    assert page.has_current_path?('/users/sign'),
      'Clicking "Daftar" does not redirect to registration form.'
    assert page.has_selector?('form'), 'Form is not there.'

    fill_in 'user_username', with: 'cobaasalaja'
    fill_in 'Alamat email', with: 'a.b@gmail.com'
    fill_in 'user_password', with: 'cobaasal'
    fill_in 'Ulangi password', with: 'cobaasal'
    fill_in 'Nama lengkap', with: 'Halo Halo'
    select 'Banten', from: 'user_province_id'
    select 'Kelas 9', from: 'user_status_id'
    fill_in 'Sekolah/institusi', with: 'Sekolah Keren'
    check 'kebijakan privasi'
    click_on 'Daftar', class: 'btn'

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
  end
end
