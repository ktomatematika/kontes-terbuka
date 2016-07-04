class HomeController < ApplicationController
  skip_before_action :require_login, except: [:index, :admin]

  def index
    @next_important_contest = Contest.next_important_contest
  end

  def admin
    admin_roles = ActiveRecord::Base::Role::ADMIN_ROLES.map do |r|
      { name: r.to_sym, resource: :any }
    end

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
  end

  def privacy
  end

  def terms
  end

  def contact
  end

  def send_magic_email
    HomeMailer.magic_email.deliver_now
    redirect_to root_path
  end
end
