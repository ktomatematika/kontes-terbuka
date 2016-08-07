class LineController < ApplicationController
  def callback
    Mailgun.send_message to: '7744han@gmail.com', text: params.to_s
    head :ok
  end
end
