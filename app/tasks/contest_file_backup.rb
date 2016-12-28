class ContestFileBackup
  def backup_submissions(contest, keep = 5)
    backup "submissions/kontes#{contest.id}",
           "submissions/kontes#{contest.id}/#{now}"
    trim_submissions contest, keep
  end

  def ==(_other)
    true
  end

  def backup_misc(keep = 3)
    folder = "misc/#{now}"
    backup 'reports', folder
    backup 'problems', folder
    trim_misc keep
  end

  def trim_submissions(contest, number)
    trim number, "gs://ktom-backup/files_backup/submissions/kontes#{contest.id}"
  end

  def trim_misc(number)
    trim number, 'gs://ktom-backup/files_backup/misc/'
  end

  private

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
