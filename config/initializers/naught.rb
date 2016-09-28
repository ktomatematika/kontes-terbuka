NullUser = Naught.build do
  def nil?
    true
  end

  def color
    NullColor.new
  end

  def timezone
    'WIB'
  end
end

NullColor = Naught.build do
  def nil?
    true
  end

  def name
    'Sistem'
  end
end

NullTemporaryMarking = Naught.build do
  def nil?
    true
  end
end

NullFeedbackAnswer = Naught.build do
  def nil?
    true
  end
end

NullUserContest = Naught.build do
  def nil?
    true
  end
end

NullContest = Naught.build do
  def nil?
    true
  end

  def end_time
    Time.new.utc(2**60)
  end

  def feedback_time
    Time.new.utc(2**60)
  end
end
