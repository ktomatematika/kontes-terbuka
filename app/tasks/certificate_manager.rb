# frozen_string_literal: true

class CertificateManager
  TEMPLATE = File.read(Rails.root.join('app/views/contests/certificate.tex.haml'))
  EMAIL_SINK = 'certificate@ktom.tomi.or.id'

  attr_reader :user_contest

  def initialize(user_cont)
    @user_contest = user_cont
    @contest = user_cont.contest
    @user = user_cont.user
    @dir = Rails.root.join('public/contest_files/certificates').to_s
    @path = "#{@dir}/#{user_cont.id}"
    @tex_path = "#{@path}.tex"
    @pdf_path = "#{@path}.pdf"

    FileUtils.mkdir_p(@dir) unless Dir.exist?(@dir)
  end

  def ==(other)
    other.class == CertificateManager && @user_contest == other.user_contest
  end

  def run
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
    data = Social.certificate_manager.send_certificate
    Mailgun.send_message to: @user.email,
                         contest: @contest,
                         subject: data.subject.get(binding),
                         text: data.text.get(binding),
                         attachment: File.new(pdf_file, 'r'),
                         bcc: EMAIL_SINK
  end

  def clean_files
    File.delete(*Dir.glob("#{@path}*"))
  end
end
