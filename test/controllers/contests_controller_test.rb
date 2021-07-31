# frozen_string_literal: true

require 'test_helper'

class ContestsControllerTest < ActionController::TestCase
  setup :login_and_be_admin, :create_items

  test 'routes' do
    assert_equal admin_contest_path(@c),
                 "/contests/#{@c.to_param}/admin"
    assert_equal summary_contest_path(@c),
                 "/contests/#{@c.to_param}/summary"
    assert_equal read_problems_contest_path(@c),
                 "/contests/#{@c.to_param}/read-problems"
    assert_equal results_contest_path(@c),
                 "/contests/#{@c.to_param}/results"
    assert_equal problem_pdf_contest_path(@c),
                 "/contests/#{@c.to_param}/problem-pdf"
    assert_equal ms_pdf_contest_path(@c),
                 "/contests/#{@c.to_param}/ms-pdf"
    assert_equal reports_contest_path(@c),
                 "/contests/#{@c.to_param}/reports"
    assert_equal contests_path,
                 '/contests'
    assert_equal new_contest_path,
                 '/contests/new'
    assert_equal contest_path(@c),
                 "/contests/#{@c.to_param}"
    assert_equal refresh_contest_path(@c),
                 "/contests/#{@c.to_param}/refresh"
    assert_equal send_certificates_contest_path(@c),
                 "/contests/#{@c.to_param}/send_certificates"
  end

  test 'admin' do
    test_abilities @c, :admin, [nil, :marker], %i[panitia admin]
    get :admin, id: @c.id
    assert_response 200
  end

  test 'new' do
    test_abilities Contest, :new, [nil, :marker, :panitia, :problem_admin],
                   [:admin]
    get :new
    assert_response 200
  end

  test 'create' do
    test_abilities Contest, :create, [nil, :marker, :panitia, :problem_admin],
                   [:admin]
    contest_hash = attributes_for(:contest, name: 'Halo')
    post :create, contest: contest_hash

    c = Contest.find_by(name: 'Halo')
    assert_not_nil c
    assert_redirected_to contest_path(c)
  end

  test 'create fail' do
    contest_hash = attributes_for(:contest)
    contest_hash.delete(:start_time)
    assert_difference('Contest.count', 0) do
      post :create, contest: contest_hash
    end
    assert_template :new
  end

  test 'show not in contest' do
    test_abilities @c, :show, [], [nil]
    @c.update(start_time: Time.zone.now + 4.seconds,
              end_time: Time.zone.now + 5.seconds)
    get :show, id: @c.id
    assert_response 200
  end

  test 'show in contest without user contest' do
    @c.update(start_time: Time.zone.now - 4.seconds,
              end_time: Time.zone.now + 5.seconds)
    get :show, id: @c.id
    assert_redirected_to new_contest_user_contest_path(@c)
  end

  test 'index' do
    test_abilities Contest, :index, [], [nil]
    get :index
    assert_response 200
  end

  test 'update' do
    test_abilities @c, :update, [nil, :panitia, :marker, :problem_admin],
                   [:admin]
    post :update, id: @c.id, contest: { name: 'Coba asal aja' }

    @c.reload
    assert_redirected_to contest_path(@c)
    assert_equal flash[:notice], "#{@c} berhasil diubah."
    assert_equal @c.name, 'Coba asal aja'
  end

  test 'update fail' do
    post :update, id: @c.id, contest: { start_time: Time.zone.now + 5.seconds,
                                        end_time: Time.zone.now - 5.seconds }

    assert_redirected_to contest_path(@c)
    assert flash[:alert].start_with? "#{@c} gagal diubah! "
  end

  test 'update upload ms' do
    test_abilities @c, :update_marking_scheme, [nil, :panitia, :marker],
                   %i[problem_admin admin]
    @user.remove_role :admin
    @user.add_role :problem_admin

    post :update, id: @c.id, contest: {
      marking_scheme: Rack::Test::UploadedFile.new(File.path(PDF),
                                                   'application/pdf')
    }

    assert_redirected_to contest_path(@c)
    assert_equal flash[:notice], "#{@c} berhasil diubah."
    assert @c.reload.marking_scheme.exists?
  end

  test 'update not allowed' do
    @user.remove_role :admin

    assert_raises { post :update, id: @c.id }
  end

  test 'destroy' do
    test_abilities @c, :destroy, [nil, :panitia, :marker, :problem_admin],
                   [:admin]
    delete :destroy, id: @c.id
    assert_nil Contest.find_by id: @c.id
  end

  test 'download_problem_pdf' do
    test_abilities @c, :download_problem_pdf, [nil], %i[panitia admin]

    uc = create(:user_contest)
    assert Ability.new(uc.user).can?(:download_problem_pdf, uc.contest)

    test_abilities create(:contest, start: 5, ends: 10),
                   :download_problem_pdf, [nil, :marker], %i[panitia admin]

    @c.update(problem_pdf: PDF)
    @c.reload
    get :download_problem_pdf, id: @c.id

    assert_response 200
    assert_equal @response.content_type, 'application/pdf'
    assert_equal IO.binread(@c.problem_pdf.path), @response.body
  end

  test 'download_marking_scheme' do
    @c.update(marking_scheme: PDF)
    @c.reload
    test_abilities @c, :download_marking_scheme, [:panitia, [:marker,
                                                        create(:long_problem)]],
                   [[:admin, create(:long_problem, contest: @c)], :admin]
    test_abilities @c, :download_marking_scheme, [:user, [:problem_admin,
                                                        create(:long_problem)]],
                   [[:marking_manager, create(:long_problem, contest: @c)], :marking_manager]
    get :download_marking_scheme, id: @c.id

    assert_response 200
    assert_equal IO.binread(@c.marking_scheme.path), @response.body
  end

  test 'download_reports' do
    test_abilities @c, :download_reports, [nil], [:panitia]

    lp = create(:long_problem, contest: @c, report: PDF)
    @c.compress_reports

    get :download_reports, id: @c.id
    assert_response 200

    Zip::File.open(@c.report_zip_location) do |file|
      assert_equal file.count, 1
      assert_equal file.first.size, lp.report.size
    end
  end

  test 'read_problems' do
    test_abilities @c, :read_problems, [nil, :marker], %i[problem_admin admin]
    post :read_problems, id: @c.id, answers: '0,1,2', problem_tex:
      Rack::Test::UploadedFile.new(File.path(TEX), 'application/x-tex')

    @c.reload
    assert_equal Paperclip.io_adapters.for(@c.problem_tex).read, File.read(TEX)
    assert_equal @c.short_problems.count, 14
    assert_equal @c.long_problems.count, 4
    3.times do |i|
      assert_equal ShortProblem.find_by(contest: @c,
                                        problem_no: (i + 1)).answer, i.to_s
    end
  end

  test 'read_problems with compile_only' do
    post :read_problems, id: @c.id, answers: '0,1,2', problem_tex:
      Rack::Test::UploadedFile.new(File.path(TEX), 'application/x-tex'),
                         compile_only: true

    @c.reload
    assert_equal Paperclip.io_adapters.for(@c.problem_tex).read, File.read(TEX)
    assert_equal @c.short_problems.count, 0
    assert_equal @c.long_problems.count, 0
  end

  test 'summary' do
    test_abilities @c, :summary, [nil, :marker], [:panitia]
    create(:long_submission, :marked,
           long_problem: create(:long_problem, contest: @c, max_score: 7))
    get :summary, id: @c.id
    assert_response 200
  end

  test 'summary without data' do
    get :summary, id: @c.id
    assert_redirected_to contest_path(@c)
    assert_equal flash[:notice], 'Tidak ada data'
  end

  test 'download_results' do
    c = create(:contest, result_released: false)
    test_abilities c, :download_results, [nil, :panitia], [:admin]

    c2 = create(:contest, start: -5, ends: -3)
    create(:feedback_question, contest: c2)
    c2.update(result_released: true)
    test_abilities c2, :download_results, [], [nil]

    get :download_results, id: @c.id

    assert_response 200
    assert @response.header['Content-Disposition']
                    .include?("filename=\"Hasil #{@c}.pdf\"")
    assert_equal @response.content_type, 'application/pdf'
    assert_equal @response.body, IO.binread(@c.results_location)
  end

  test 'refresh' do
    test_abilities @c, :refresh, [nil, :panitia], [:admin]

    post :refresh, id: @c.id
    assert_redirected_to admin_contest_path(@c)
    assert_equal flash[:notice], 'Refreshed!'

    jobs = Delayed::Job.where(queue: "contest_#{@c.id}").select do |j|
      handler = YAML.load(j.handler)
      handler.method_name == :refresh_results_pdf
    end
    assert_equal jobs.count, 1, 'Jobs created after refresh is not 1.'

    handler = YAML.load(jobs.first.handler)
    assert_equal handler.method_name, :refresh_results_pdf,
                 'Calling refresh does not call refresh results pdf.'
    assert_in_delta Time.zone.now, jobs.first.run_at, 5,
                    'Calling refresh does not refresh immediately.'
  end

  test 'send_certificates' do
    test_abilities @c, :send_certificates, [nil, :panitia], [:admin]

    post :send_certificates, id: @c.id
    assert_redirected_to admin_contest_path(@c)
    assert_equal flash[:notice], 'Sertifikat sedang dikirim!'

    jobs = Delayed::Job.where(queue: nil).select do |j|
      handler = YAML.load(j.handler)
      handler.method_name == :send_certificates
    end
    assert_equal jobs.count, 1, 'Jobs created after send certificates is not 1.'
    assert_in_delta Time.zone.now, jobs.first.run_at, 5,
                    'Calling send_certificates does not do it immediately.'
  end

  private def create_items
    @c = create(:contest)
  end
end
