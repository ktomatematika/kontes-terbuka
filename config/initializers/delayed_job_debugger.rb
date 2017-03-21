class DelayedJobDebugger
  def run
    Delayed::Worker.logger.debug ENV['PATH']
  end
end
