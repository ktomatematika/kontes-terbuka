# frozen_string_literal: true

class ReferrersController < ApplicationController
  authorize_resource

  def reset
    lainnya = Referrer.find_by(name: 'Lainnya')
    # TODO: Rails is hard
    # rubocop:disable Rails/SkipsModelValidations
    User.where(referrer: lainnya).update_all(referrer: nil)
    # rubocop:enable Rails/SkipsModelValidations
    redirect_to admin_path, notice: 'Lainnya dibuang semua!'
  end
end
