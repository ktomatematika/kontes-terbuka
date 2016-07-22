class SubmissionPagesController < ApplicationController
  authorize_resource
  def download
    @submission_page = SubmissionPage.find(params[:id])
    authorize! :download, @submission_page
    send_file @submission_page.submission.path
  end
end
