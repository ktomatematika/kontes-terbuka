# frozen_string_literal: true

require 'test_helper'

class MailgunTest < ActiveSupport::TestCase
  test 'send normal email' do
    assert_equal Mailgun.send_message(to: 'a@b.com', text: 'asdf'),
                 { to: 'a@b.com',
                   from: 'Kontes Terbuka Olimpiade Matematika ' \
                   '<mail@ktom.tomi.or.id>',
                   text: "Salam sejahtera,\n\nasdf\n\n" \
                   "Salam,\nTim KTO Matematika" },
                 'Sending a normal email does not even work.'
  end

  test 'send email with to many separated by commas should fail' do
    assert_raises('You cannot send to many. Use BCC instead.') do
      Mailgun.send_message(to: 'a@b.com,c@d.com', text: 'asdf')
    end
  end

  test 'send email with to many array should fail' do
    assert_raises('You cannot send to many. Use BCC instead.') do
      Mailgun.send_message(to: ['a@b.com', 'c@d.com'], text: 'asdf')
    end
  end

  test 'send email with to many array with force_to_many should pass' do
    assert_equal Mailgun.send_message(to: 'a@b.com,c@d.com',
                                      text: 'asdf', force_to_many: true),
                 { to: 'a@b.com,c@d.com',
                   from: 'Kontes Terbuka Olimpiade Matematika ' \
                   '<mail@ktom.tomi.or.id>',
                   text: "Salam sejahtera,\n\nasdf\n\n" \
                   "Salam,\nTim KTO Matematika" },
                 'Sending an email with force_to_many does not work.'
  end

  test 'send email with contest params should have contest added to subject' do
    contest = create(:contest, name: 'Kontes Halo')
    assert_equal Mailgun.send_message(to: 'a@b.com', contest: contest,
                                      text: 'asdf', subject: 'Subjek'),
                 { to: 'a@b.com',
                   from: 'Kontes Terbuka Olimpiade Matematika ' \
                   '<mail@ktom.tomi.or.id>',
                   text: "Salam sejahtera,\n\nasdf\n\n" \
                   "Salam,\nTim KTO Matematika",
                   subject: 'Kontes Halo: Subjek' },
                 'Sending an email with contest param does not work.'
  end

  test 'send email with bcc_array should put the bcc_array to bcc' do
    assert_equal Mailgun.send_message(to: 'a@b.com',
                                      bcc: 'c@d.com',
                                      bcc_array: ['e@f.com', 'g@h.com'],
                                      text: 'asdf'),
                 { to: 'a@b.com', bcc: 'c@d.com,e@f.com,g@h.com',
                   from: 'Kontes Terbuka Olimpiade Matematika ' \
                   '<mail@ktom.tomi.or.id>',
                   text: "Salam sejahtera,\n\nasdf\n\n" \
                   "Salam,\nTim KTO Matematika" },
                 'Sending an email with bcc_array does not work.'
  end

  test 'send email without to adds the to' do
    assert_equal Mailgun.send_message(text: 'asdf'),
                 { to: 'mail@ktom.tomi.or.id',
                   from: 'Kontes Terbuka Olimpiade Matematika ' \
                   '<mail@ktom.tomi.or.id>',
                   text: "Salam sejahtera,\n\nasdf\n\n" \
                   "Salam,\nTim KTO Matematika" },
                 'Sending an email without to adds the sender email to the to.'
  end
end
