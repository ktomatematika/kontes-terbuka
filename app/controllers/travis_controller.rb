class TravisController < ApplicationController
  skip_before_action :verify_authenticity_token, :require_login

  def pass
    return unless valid?
    payload = JSON.parse(params[:payload])

    RestClient.post url,
                    activity: "Commit #{payload['status_message']}!",
                    title: "'#{payload['message']}' to " \
                    "branch '#{payload['branch']}'",
                    body: "Committed by #{payload['committer_name']}. " \
                      "[Link](#{payload['build_url']})"

    head :ok
  end

  private

  def valid?
    true
    # digest = Digest::SHA2.new.update(ENV['HTTP_TRAVIS_REPO_SLUG'] +
    #                                  ENV['TRAVIS_USER_TOKEN'])
    # digest == ENV['HTTP_AUTHORIZATION']
  end

  def url
    'https://hooks.glip.com/webhook/0b581173-e84c-4187-9907-8587b4ee3b57'
  end
end
