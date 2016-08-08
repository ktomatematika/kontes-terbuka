class LineController < ApplicationController
  skip_before_action :verify_authenticity_token, :require_login

  def callback
    signature = request.headers['HTTP_X_LINE_CHANNELSIGNATURE']
    unless LineClient.validate_signature(request.raw_post, signature)
      head :bad_request
    end

    Line::Bot::Receive::Request.new(request.env).data.each do |msg|
      mid = msg.from_mid
      response = 'KTOM-Chan ga paham :('

      case msg.content
      when Line::Bot::Message::Text
        unless /mid/i.match(msg.content[:text]).nil?
          response = mid
        end
      end

      LineClient.send_text to_mid: mid, text: response
    end

    head :ok
  end
end
