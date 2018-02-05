# frozen_string_literal: true

module Mailgun
  extend self

  KEY = ENV['MAILGUN_API_KEY']
  DOMAIN = 'ktom.tomi.or.id'
  URL = "https://api:#{KEY}@api.mailgun.net/v3/#{DOMAIN}/messages"
  EMAIL = "mail@#{DOMAIN}"
  FROM = "Kontes Terbuka Olimpiade Matematika <#{EMAIL}>"
  TRIES = 3
  # Sends a message with Mailgun. Pass a hash of options.
  # Some options:
  # to: message recipient. Please only specify one recipient; if you want more,
  # BCC it.
  # force_to_many: Force send to many, instead of BCC.
  # text: contents of the email
  # subject: subject
  # contest: specify a contest to put contest tag
  # bcc_array: BCC params as an array.
  # tries: number of attempts, defaults to TRIES variable above
  def send_message(**params)
    make_valid!(params)
    text = params[:text]
    params[:text] = Social.email_template.get binding

    check_force_to_many!(params)
    add_contest!(params)
    convert_bcc!(params)

    case Rails.env
    when 'production'
      tries = params.delete(:tries) || TRIES
      send_email(params, tries)
    when 'development'
      Ajat.info "mailgun|message=#{params}"
    when 'test'
      params
    end
  end

  private

  def send_email(params, tries)
    RestClient.post URL, params if Rails.env.production?
  rescue RestClient::Exceptions::OpenTimeout
    tries -= 1
    retry unless tries.zero?
  end

  def make_valid!(params)
    params[:to] ||= EMAIL
    params[:from] ||= FROM
  end

  def check_force_to_many!(params)
    if (params[:to].include?(',') || params[:to].is_a?(Array)) &&
       !params[:force_to_many]
      raise 'You cannot send to many. Use BCC instead.'
    end
    params.delete(:force_to_many)
  end

  def add_contest!(params)
    return unless params[:contest]
    params[:subject] = "#{params.delete(:contest)}: #{params[:subject]}"
  end

  def convert_bcc!(params)
    return unless params[:bcc_array]
    params[:bcc].nil? ? params[:bcc] = '' : params[:bcc] += ','
    params[:bcc] += params.delete(:bcc_array).join(',')
  end
end
