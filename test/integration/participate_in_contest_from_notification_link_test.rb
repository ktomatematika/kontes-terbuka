require 'test_helper'

class ParticipateInContestFromNotificationLinkTest <
  ActionDispatch::IntegrationTest
  test 'submit random shit in contest' do
    contest = create(:full_contest, start: -1000,
                                    ends: 3000, result: 5000,
                                    feedback: 7000)
    user = create(:user, password: 'asdfasdf', referrer: Referrer.take)
    user.enable

    visit contest_path(contest)
    assert page.has_current_path?(
      sign_users_path(redirect: contest_path(contest))
    ),
           'It does not require you to login.'
    assert page.has_content?('masuk terlebih dahulu'), 'Flash does not appear.'

    within('#login') do
      fill_in 'username', with: user.username
      fill_in 'password', with: 'asdfasdf'
      click_on 'Masuk', class: 'btn'
    end

    assert page.has_current_path?(new_contest_user_contest_path(contest)),
           'Signing in does not redirect you to the new user contest page.'

    sleep(1)
    click_on 'menyetujui'
    assert page.has_current_path?(contest_path(contest)),
           'The button does not redirect you to the contest page.'

    user_contest = UserContest.find_by(contest: contest, user: user)
    assert_not_nil user_contest, 'User Contest is not created.'

    assert page.has_content?('Tunggu sebentar'), 'Nag is not displayed.'
    sleep(4)

    find('#close-nag').click

    contest.short_problems.each do |sp|
      fill_in "short_submission_#{sp.id}", with: sp.id
    end

    within('#bagian-a') { click_on 'Jawab' }
    assert page.has_content?('berhasil dikirimkan'), 'Submissions are not sent.'

    contest.short_problems.each do |sp|
      assert_equal sp.short_submissions.find_by(user_contest_id: user_contest)
        .answer, sp.id.to_s,
                   'Short Submission is not submitted.'
    end

    # TODO: add for long problems
  end
end
