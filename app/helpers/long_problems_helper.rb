module LongProblemsHelper
  # Method to determine whether all scripts have been marked.
  def all_marked
    markers_count = User.with_role(:marker, @long_problem).count
    temporary_count = @long_problem.temporary_markings.count
    @long_submissions.length == markers_count * temporary_count
  end

  # Method to show 'Sudah' for other markers if temporary marking exists.
  def show_if_done_array(ls)
    @markers.map do |m|
      TemporaryMarking.find_by(long_submission: ls, user: m).nil? ? '' : 'Sudah'
    end
  end
end
