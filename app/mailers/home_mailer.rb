class HomeMailer < ApplicationMailer
 default from: 'ktom@tomi.or.id'

 def magic_email
  mail(to: '7744han@gmail.com', subject: 'This is the magic email!')
 end
end
