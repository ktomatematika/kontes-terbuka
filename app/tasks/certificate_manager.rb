class CertificateManager
  attr_accessor :user_contest, :contest, :user, :tex_path, :pdf_path
  TEMPLATE = File.read(Rails.root.join('app', 'views', 'contests',
                                       'certificate.tex.haml'))

  def initialize(uc)
    @user_contest = uc
    @contest = uc.contest
    @user = uc.user
    @path = Rails.root.join('public', 'contest_files',
                            'certificates', uc.id.to_s).to_s
    @tex_path = @path + '.tex'
    @pdf_path = @path + '.pdf'
  end

  def run
    @user_contest = UserContest.where(id: @user_contest.id).processed.first
    compile_to_pdf certificate_tex
    send_certificate @pdf_path
    clean_files
  end

  def certificate_tex
    Haml::Engine.new(TEMPLATE).render(Object.new,
                                      name: @user.fullname,
                                      contest: @contest,
                                      award: @user_contest.award)
  end

  def compile_to_pdf(contents)
    File.write(@tex_path, contents)
    # do twice to render pdf correctly
    Dir.chdir(File.dirname(@tex_path)) do
      2.times do
        `pdflatex -interaction=nonstopmode #{@tex_path}`
      end
    end
  end

  def send_certificate(pdf_file)
    text = "Terlampir adalah sertifikat untuk #{@contest}. " \
           'Sekali lagi, terima kasih atas partisipasinya!'
    Mailgun.send_message to: @user.email,
                         contest: @contest,
                         subject: 'Sertifikat Kontes',
                         text: text,
                         attachment: File.new(pdf_file, 'r')
  end

  def clean_files
    File.delete(*Dir.glob(@path + '*'))
  end
end
