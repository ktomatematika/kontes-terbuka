module LongProblemsHelper
  # Method to determine whether all scripts have been marked.
  def all_marked
    markers_count = User.with_role(:marker, @long_problem).count
    temporary_count = @long_problem.temporary_markings.count
    @long_submissions.length == markers_count * temporary_count
  end
end
