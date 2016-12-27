module Mailgun
  extend self

  KEY = ENV['MAILGUN_API_KEY']
  DOMAIN = 'ktom.tomi.or.id'.freeze
  URL = "https://api:#{KEY}@api.mailgun.net/v3/#{DOMAIN}/messages".freeze
  EMAIL = "mail@#{DOMAIN}".freeze
  FROM = "Kontes Terbuka Olimpiade Matematika <#{EMAIL}>".freeze
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
    params[:to] = EMAIL if params[:to].nil?
    params[:from] = FROM
    params[:text] = "Salam sejahtera,\n\n" + params[:text] +
                    "\n\nSalam,\nTim KTO Matematika"

    params = check_force_to_many(params)
    params = add_contest(params) if params[:contest]
    params = convert_bcc(params) if params[:bcc_array]

    if Rails.env.production?
      RestClient.post URL, params
    elsif Rails.env.development?
      Ajat.info 'mailgun|message=' + params.to_s
    elsif Rails.env.test?
      params
    end
  end

  private

  def check_force_to_many(params)
    if (params[:to].include?(',') || params[:to].is_a?(Array)) &&
       !params[:force_to_many]
      raise 'You cannot send to many. Use BCC instead.'
    end
    params.delete(:force_to_many)
    params
  end

  def add_contest(params)
    params[:subject] = "#{params[:contest]}: #{params[:subject]}"
    params.delete(:contest)
    params
  end

  def convert_bcc(params)
    params[:bcc] = '' if params[:bcc].nil?
    params[:bcc] += ',' unless params[:bcc].empty?
    params[:bcc] += params[:bcc_array].join(',')
    params.delete(:bcc_array)
    params
  end
end
