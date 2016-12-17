class ContestFileBackup
  def backup_submissions(contest)
    backup "submissions/kontes#{contest.id}", "kontes#{contest.id}/#{now}"
    trim_submissions contest
  end

  def backup_misc
    folder = "misc/#{now}"
    backup 'reports', folder
    backup 'problems', folder
    trim_misc
  end

  private

  def trim_submissions(contest)
    trim 30, "gs://ktom-backup/files_backup/submissions/kontes#{contest.id}"
  end

  def trim_misc
    trim 3, 'gs://ktom-backup/files_backup/misc/'
  end

  def backup(location, bucket_link)
    location = '/home/ktom/kontes-terbuka/shared/public/' \
      "contest_files/#{location}"
    bucket_link = "gs://ktom-backup/files_backup/#{bucket_link}"
    `gsutil -m cp -r #{location} #{bucket_link}`
  end

  def trim(number, bucket_link)
    `gsutil ls #{bucket_link} | tac | tail -n +#{number + 1} \
    | xargs -I {} gsutil -m rm -r -- {}`
  end

  def now
    Time.zone.now.strftime('%y%d%m_%H%M%S')
  end
end
