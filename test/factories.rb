FactoryGirl.define do
  factory :color do
    name 'Merah'
  end

  factory :status do
    name 'Kuliah'
  end

  factory :province do
    name 'Sulawesi Selatan'
    timezone 'WITA'
  end

  factory :user do
    username 'default'

    transient do
      pass 'qwerqwerty'
    end

    password { pass }
    password_confirmation { pass }
    email { (username || 'qwerqwer') + '@a.b' }
    fullname 'qwerqwer'
    province do
      Province.first || (if username.nil? || username.empty?
                           create :province, name: 'asdf'
                         else
                           create :province, name: username
                         end)
    end
    status do
      Status.first || (if username.nil? || username.empty?
                         create :status, name: 'asdf'
                       else
                         create :status, name: username
                       end)
    end
    color do
      Color.first || (if username.nil? || username.empty?
                        create :color, name: 'asdf'
                      else
                        create :color, name: username
                      end)
    end
    school 'qwerty'
    terms_of_service '1'
  end
end
