class FacebookPost
  include Rails.application.routes.url_helpers
  attr_reader :contest

  def initialize(ctst)
    @contest = ctst
    @graph = Koala::Facebook::API.new ENV['FACEBOOK_ACCESS_TOKEN'],
                                      ENV['FACEBOOK_SECRET']
    @data = Social.facebook_post
  end

  def ==(other)
    other.class == FacebookPost && @contest == other.contest
  end

  def contest_starting(time_text)
    post_to_facebook @data.contest_starting.get binding
  end

  def contest_started
    post_to_facebook @data.contest_started.get binding
  end

  def contest_ending(time_text)
    post_to_facebook @data.contest_ending.get binding
  end

  def results_released
    post_to_facebook @data.results_released.get binding
  end

  def feedback_ending(time_text)
    post_to_facebook @data.feedback_ending.get binding
  end

  def certificate_sent
    post_to_facebook @data.certificate_sent.get binding
  end

  private def post_to_facebook(message)
    message = "Salam sejahtera,\n\n#{message}"
    if Rails.env.test?
      message # make the methods testable
    else
      @graph.put_object ENV['FACEBOOK_PAGE_ID'], 'feed', message: message
    end
  end
end
