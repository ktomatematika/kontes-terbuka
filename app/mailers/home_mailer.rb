class HomeMailer < ApplicationMailer
  default from: 'ktom@tomi.or.id'

  def magic_email
    @email = 'jonathanmulyawan@gmail.com'
    mail(to: @email, subject: 'This is the magic email!')
  end
end
