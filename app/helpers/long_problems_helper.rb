# frozen_string_literal: true

module LongProblemsHelper
  # Method to show 'Sudah' for other markers if temporary marking exists.
  def show_if_done_array(long_sub)
    @markers.map do |usr|
      TemporaryMarking.find_by(long_submission: long_sub, user: usr).nil? ? '' : 'Sudah'
    end
  end
end
