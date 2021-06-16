# frozen_string_literal: true

class SetCertificateSentNotNull < ActiveRecord::Migration
  def change
    change_column_null :user_contests, :certificate_sent, false, false
  end
end
