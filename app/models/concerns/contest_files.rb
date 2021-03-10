# frozen_string_literal: true

module ContestFiles
  extend ActiveSupport::Concern

  def compress_reports
    File.delete(report_zip_location) if File.file?(report_zip_location)
    ZipFileGenerator.new(reports_location, report_zip_location).write
  end

  def compress_submissions
    File.delete(submissions_zip_location) if File.file?(report_zip_location)
    ZipFileGenerator.new(submissions_location, submissions_zip_location).write
  end

  def report_zip_location
    "#{reports_location}.zip"
  end

  def submissions_zip_location
    "#{submissions_location}.zip"
  end

  def results_location
    Rails.root.join('public', 'contest_files', 'results', "#{id}.pdf").to_s
  end

  def refresh_results_pdf
    contest = self
    b = binding
    pdf = WickedPdf.new.pdf_from_string(
      ERB.new(File.read(results_template)).result(b),
      orientation: 'Landscape',
      header: { right: Time.zone.now
                           .strftime('Versi %d-%m-%Y %H:%M:%S GMT%z') },
      footer: { left: "Hasil #{contest}",
                right: 'Halaman [page] dari [topage]' }
    )

    File.delete(results_location) if File.file?(results_location)
    FileUtils.mkdir_p(File.dirname(results_location)) unless File.directory?(File.dirname(results_location))
    File.open(results_location, 'wb') { |f| f << pdf }
  end

  private def reports_location
    Rails.root.join('public', 'contest_files', 'reports', id.to_s).to_s
  end

  private def submissions_location
    Rails.root.join('public', 'contest_files', 'submissions',
                    "kontes#{id}").to_s
  end

  private def results_template
    Rails.root.join('app', 'views', 'contests', 'download_results.html.erb')
  end
end
