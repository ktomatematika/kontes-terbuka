RailsAdmin.config do |config|
  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # PaperTrail >= 3.0.0
  config.audit_with :paper_trail, 'User', 'PaperTrail::Version'

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard # mandatory
    index # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'User' do
    object_label_method do
      :username
    end
  end

  def long_submission_name
    "#{contest_name} no. #{long_problem.contest_no} hal. #{page}"
  end
  config.model 'LongSubmission' do
    object_label_method do
      :long_submission_name
    end
  end
end
