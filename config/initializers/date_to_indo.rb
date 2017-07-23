# frozen_string_literal: true

module ActiveSupport
  class TimeWithZone
    def to_indo
      months = %w[Januari Februari Maret April Mei Juni Juli
                  Agustus September Oktober November Desember]
      long_days = %w[Minggu Senin Selasa Rabu Kamis
                     Jumat Sabtu]

      "#{long_days[wday]}, #{day} #{months[month - 1]} #{year} " \
      "jam #{hour.to_s.ljust(2, '0')}:#{min.to_s.ljust(2, '0')} #{zone}"
    end
  end
end
