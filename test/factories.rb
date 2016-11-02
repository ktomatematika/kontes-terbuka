FactoryGirl.define do
  factory :user_referrer do
    
  end
  factory :market_order do
    
  end
  sequence :unique do |n|
    name = 'aaaaaaaa'
    n.times { name.succ! }
    name
  end

  sequence :number do |n|
    n + 1
  end

  factory :color do
    name { generate(:unique) }
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

  factory :feedback_answer do
    answer 'Saya baik!'
    feedback_question
    user_contest
  end

  factory :feedback_question do
    question 'Halo, apa kabar?'
    contest
  end

  factory :long_problem do
    contest
    problem_no { generate(:number) }
    statement 'Esai'
  end

  factory :long_submission do
    long_problem
    user_contest

    trait :marked do
      score 6
      feedback 'Jangan lupa dimasukin balik jawaban fungsinya, bodoh'
    end
  end

  factory :notification do
    event 'contest_ending'
    time_text '3 jam'
    description '3 jam sebelum kontes selesai'
    seconds 180
  end

  factory :point_transaction do
    point 10
    description 'Kontes Bodoh'
  end

  factory :province do
    name { generate(:unique) }
    timezone 'WITA'
  end

  factory :short_problem do
    contest
    problem_no { generate(:number) }
    statement 'Isian'
    answer 0
  end

  factory :short_submission do
    short_problem
    user_contest
  end

  factory :status do
    name { generate(:unique) }
  end

  factory :submission_page do
    page_number { generate(:number) }
    long_submission
  end

  factory :temporary_marking do
    user
    long_submission

    trait :filled do
      mark 3
      tags 'udah lumayan'
    end
  end

  factory :user do
    username { generate(:unique) }
    password 'qwerqwerty'
    password_confirmation { password }
    email { generate(:unique) + '@a.b' }
    fullname 'qwerqwer'
    province
    status
    color
    school 'qwerty'
    terms_of_service '1'
  end

  factory :user_contest do
    contest
    user
  end

  factory :user_notification do
    user
    notification
  end
end
