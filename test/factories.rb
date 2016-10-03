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
      Province.take || (if username.nil? || username.empty?
                          create :province, name: 'asdf'
                        else
                          create :province, name: username
                        end)
    end
    status do
      Status.take || (if username.nil? || username.empty?
                        create :status, name: 'asdf'
                      else
                        create :status, name: username
                      end)
    end
    color do
      Color.take || (if username.nil? || username.empty?
                       create :color, name: 'asdf'
                     else
                       create :color, name: username
                     end)
    end
    school 'qwerty'
    terms_of_service '1'
  end

  factory :contest do
    transient do
      start 0
      ends 20
      result 40
      feedback 60
    end

    name 'Kontes Coba'
    start_time { Time.zone.now + start.seconds }
    end_time { Time.zone.now + ends.seconds }
    result_time { Time.zone.now + result.seconds }
    feedback_time { Time.zone.now + feedback.seconds }
  end

  factory :short_problem do
    contest { Contest.take || create(:contest) }
    problem_no 1
    statement 'Isian'
    answer 0
  end

  factory :long_problem do
    contest { Contest.take || create(:contest) }
    problem_no 1
    statement 'Esai'
  end

  factory :user_contest do
    contest { Contest.take || create(:contest) }
    user { User.take || create(:user) }
  end
end
