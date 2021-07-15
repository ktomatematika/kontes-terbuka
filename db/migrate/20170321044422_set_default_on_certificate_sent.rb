# frozen_string_literal: true

class SetDefaultOnCertificateSent < ActiveRecord::Migration
  def change
    change_column :user_contests, :certificate_sent, :boolean, default: false
  end
end
