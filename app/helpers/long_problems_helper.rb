module LongProblemsHelper
  # Method to show 'Sudah' for other markers if temporary marking exists.
  def show_if_done_array(ls)
    @markers.map do |m|
      TemporaryMarking.find_by(long_submission: ls, user: m).nil? ? '' : 'Sudah'
    end
  end
end
