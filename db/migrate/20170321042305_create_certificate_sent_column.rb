# frozen_string_literal: true

class CreateCertificateSentColumn < ActiveRecord::Migration
  def change
    add_column :user_contests, :certificate_sent, :boolean
  end
end
