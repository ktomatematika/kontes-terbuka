# frozen_string_literal: true

module TimeParser
  refine String do
    def parse_hhmmss
      matches = /(\d\d):(\d\d):(\d\d)/.match(self)
      return unless matches

      matches[1].to_i.hours + matches[2].to_i.minutes + matches[3].to_i.seconds
    end
  end
end
