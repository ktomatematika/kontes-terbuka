class LineController < ApplicationController
  skip_before_action :verify_authenticity_token, :require_login

  def callback
    signature = request.headers['HTTP_X_LINE_CHANNELSIGNATURE']
    unless LineClient.validate_signature(request.raw_post, signature)
      head :bad_request
    end

    receive_req = Line::Bot::Receive::Request.new request.env

    receive_req.data.each do |msg|
      case msg.content
      when Line::Bot::Message::Text
        LineClient.send_text to_mid: msg.from_mid, text: msg.content.to_s
      when Line::Bot::Operation::AddedAsFriend
        LineClient.send_text to_mid: msg.from_mid, text: msg.content.to_s
      end
    end

    head :ok
  end
end
