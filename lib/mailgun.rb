module Mailgun
  extend self

  if Rails.env == 'production'
    KEY = ENV['MAILGUN_API_KEY']
  else
    require 'mailgun_api_key'
    KEY = MailgunApiKey::MAILGUN_API_KEY
  end

  DOMAIN = 'ktom.tomi.or.id'.freeze
  URL = "https://api:#{KEY}@api.mailgun.net/v3/#{DOMAIN}/messages".freeze
  FROM = "Kontes Terbuka Olimpiade Matematika <mail@#{DOMAIN}>".freeze

  # rubocop:disable AbcSize, MethodLength
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
    params[:to] = 'no-reply@ktom.tomi.or.id' if params[:to].nil?

    if params[:to].include?(',') && !params[:force_to_many]
      raise 'You cannot send to many. Use BCC instead.'
    end
    params[:from] = FROM
    params[:text] += "\n\nSalam,\nTim KTO Matematika"

    unless params[:contest].nil?
      params[:subject] = "[#{params[:contest]}] #{params[:subject]}"
      params.delete(:contest)
    end

    unless params[:bcc_array].nil?
      params[:bcc] += (',' + params[:bcc_array].join(', '))
      params.delete(:bcc_array)
    end

    RestClient.post URL, params
  end
end
