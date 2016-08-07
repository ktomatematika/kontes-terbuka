class LineController < ApplicationController
  skip_before_action :verify_authenticity_token, :require_login

  def callback
    signature = request.headers['HTTP_X_LINE_CHANNELSIGNATURE']
    unless LineClient.validate_signature(request.raw_post, signature)
      head :bad_request
    end

    receive_req = Line::Bot::Receive::Request.new request.env

    receive_req.data.each do |msg|
      mid = msg.from_mid
      profile = LineClient.get_user_profile(mid).contacts.first.display_name

      case msg.content
      when Line::Bot::Message::Text
        text = msg.content[:text]
        match = (/^Selamat (.*), KTOM/.match text)
        if !match.nil?
          response = "Selamat #{match[1]}, #{profile}! MID kamu #{mid}."
        elsif text == 'Afif bodoh'
          response = 'Memang bego'
        else
          response = 'Halo! Saya mau asal aja.'
        end

        LineClient.send_text to_mid: mid, text: response
      when Line::Bot::Operation::AddedAsFriend
        LineClient.send_text to_mid: mid, text: 'Halo!'
      end
    end

    head :ok
  end
end
