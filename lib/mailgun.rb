# frozen_string_literal: true

module Mailgun
  extend self

  KEY = ENV['MAILGUN_API_KEY']
  DOMAIN = 'ktom.tomi.or.id'
  URL = "https://api:#{KEY}@api.mailgun.net/v3/#{DOMAIN}/messages"
  EMAIL = "mail@#{DOMAIN}"
  FROM = "Kontes Terbuka Olimpiade Matematika <#{EMAIL}>"
  # Sends a message with Mailgun. Pass a hash of options.
  # Some options:
  # to: message recipient. Please only specify one recipient; if you want more,
  # BCC it.
  # force_to_many: Force send to many, instead of BCC.
  # text: contents of the email
  # subject: subject
  # contest: specify a contest to put contest tag
  # bcc_array: BCC params as an array.
  def send_message(**params)
    make_valid!(params)
    text = params[:text]
    url = params[:url]
    params[:text] = Social.email_template.get binding
    email_notification = Social.email_notifications.to_h
    email_notification.each do |event|
      event.each do |key|
        params[:text] = Social.email_template_notif.get binding if key['subject'] == params[:subject]
      end
    end

    check_force_to_many!(params)
    add_contest!(params) if params[:contest]
    convert_bcc!(params) if params[:bcc_array]

    RestClient.post URL, params if Rails.env.production?
    Ajat.info "mailgun|message=#{params}" if Rails.env.development?
    params if Rails.env.test?
  end

  private def make_valid!(params)
    params[:to] ||= EMAIL
    params[:from] ||= FROM
  end

  private def check_force_to_many!(params)
    if (params[:to].include?(',') || params[:to].is_a?(Array)) &&
       !params[:force_to_many]
      raise 'You cannot send to many. Use BCC instead.'
    end

    params.delete(:force_to_many)
  end

  private def add_contest!(params)
    params[:subject] = "#{params[:contest]}: #{params[:subject]}"
    params.delete(:contest)
  end

  private def convert_bcc!(params)
    params[:bcc].nil? ? params[:bcc] = '' : params[:bcc] += ','
    params[:bcc] += params[:bcc_array].join(',')
    params.delete(:bcc_array)
  end
end
