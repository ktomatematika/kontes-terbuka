class LineController < ApplicationController
  skip_before_action :verify_authenticity_token, :require_login

  def callback
    signature = request.headers['HTTP_X_LINE_CHANNELSIGNATURE']
    unless LineClient.validate_signature(request.raw_post, signature)
      head :bad_request
    end

    receive_req = Line::Bot::Receive::Request.new params

    receive_req.data.each do |msg|
      if msg.content == Line::Bot::Message::Text
        LineClient.send_text to: msg.from_mid, text: msg.content[:text]
      end
    end

    head :ok
  end
end
