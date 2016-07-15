class HomeController < ApplicationController
  skip_before_action :require_login, except: [:index, :admin]

  def index
    @next_important_contest = Contest.next_important_contest
    @prev_contests = Contest.where('end_time < ?', Time.zone.now)
                            .limit(8).order('end_time desc')
  end

  def admin
    admin_roles = ActiveRecord::Base::Role::ADMIN_ROLES.map do |r|
      { name: r.to_sym, resource: :any }
    end
    Ajat.info "app_admin|uid:#{current_user.id}"

    unless current_user.has_any_role?(*admin_roles)
      raise CanCan::AccessDenied, 'Unauthorized'
    end
  end

  def faq
  end

  def book
  end

  def donate
  end

  def about
    @photo_dictionary = {}
    Dir.glob('app/assets/images/panitia/*').each do |img|
      img_file = img.split('/').last
      image_path = 'panitia/' + img_file
      image_tag = ActionController::Base.helpers.image_tag(image_path)
      @photo_dictionary[img_file] = image_tag.tr('"', "'").html_safe
    end
  end

  def privacy
  end

  def terms
  end

  def contact
  end
end
