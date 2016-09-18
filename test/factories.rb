FactoryGirl.define do
  factory :color do
    name 'Merah'
  end

  factory :status do
    name 'Kuliah'
  end

  factory :province do
    name 'Jawa Barat'
    timezone 'WIB'
  end

  factory :user do
    username 'default'
    password { username || 'qwerqwer' }
    password_confirmation { username || 'qwerqwer' }
    email { (username || 'qwerqwer') + '@a.b' }
    fullname { username || 'qwerqwer' }
    province { Province.first }
    status { Status.first }
    school { username || 'qwerqwer' }
    color { Color.first }
    terms_of_service '1'
  end
end
