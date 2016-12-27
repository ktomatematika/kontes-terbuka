class HomeController < ApplicationController
  skip_before_action :require_login, except: [:index, :admin]

  def index
    @next_important_contest = Contest.next_important_contest
    @prev_contests = Contest.where('end_time < ?', Time.zone.now)
                            .limit(8).order('end_time desc')
  end

  def admin
    Ajat.info "app_admin|uid:#{current_user.id}|uname:#{current_user}"

    authorize! :admin, Application

    # TODO: Henry akan membereskan query n+1 ini.
    @all_lp = LongProblem.joins { contest }.order do
      [contest.result_time.desc, problem_no.asc]
    end
    @long_problems = @all_lp.includes(:contest).select do |lp|
      can? :mark_final, lp
    end

    @panitia = User.with_role(:panitia).order(:username)

    @referrers = Referrer.all
  end

  def about
    @photo_dictionary = Dir.glob('app/assets/images/panitia/*').map do |img|
      img_file = img.split('/').last
      image_path = 'panitia/' + img_file
      image_tag = ActionController::Base.helpers.image_tag(image_path)
      [img_file, image_tag.tr('"', "'")]
    end.to_h
  end

  def faq; end

  def book; end

  def donate; end

  def privacy; end

  def terms; end

  def contact; end

  def masq
    authorize! :masq, Application
    if User.find_by(username: params[:username]).nil?
      redirect_to admin_path, alert: 'Ga ketemu usernya :('
    else
      session[:masq_username] = params[:username]
      redirect_to home_path, notice: 'Masq!'
    end
  end

  def unmasq
    session[:masq_username] = nil
    redirect_to home_path, notice: 'Unmasq!'
  end
end
