class TemporaryMarkingsController < ApplicationController
  def new_on_long_problem
    if (!current_user.has_role?(:marker, @long_problem) ||
        @long_problem.start_mark_final) && can?(:mark_final, @long_problem)
      redirect_to mark_final_path(@long_problem)
    else
      authorize! :mark_solo, @long_problem
      mark
      @markers = @markers.where.not(id: current_user.id)
    end
  end

  def create_on_long_problem
    params[:marking].each do |id, val|
      mark = val[:mark]
      tags = val[:tags]

      update_hash = { mark: LongSubmission::SCORE_HASH.key(mark), tags: tags }
      update_hash.delete(:mark) if mark.empty?
      update_hash.delete(:tags) if tags.empty?

      TemporaryMarking.find_or_initialize_by(long_submission_id: id,
                                             user: current_user)
                      .update(update_hash)
    end
    redirect_to mark_solo_path(params[:id]), notice: 'Nilai berhasil diupdate!'
  end
end
