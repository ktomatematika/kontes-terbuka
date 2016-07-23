class SubmissionPagesController < ApplicationController
  after_action do
    authorize! params[:action].to_sym, @submission_page || SubmissionPage
  end

  def download
    @submission_page = SubmissionPage.find(params[:id])
    authorize! :download, @submission_page
    send_file @submission_page.submission.path
  end
end
