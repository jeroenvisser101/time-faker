require 'working_hours'
require 'csv'

WorkingHours::Config.time_zone = 'Amsterdam'
WorkingHours::Config.working_hours = {
  wed: { '09:00' => '18:00' },
  thu: { '09:00' => '18:00' },
  fri: { '09:00' => '18:00' }
}
WorkingHours::Config.holidays = [
  DateTime.new(2013, 11, 24),
  DateTime.new(2013, 12, 25),
  DateTime.new(2013, 12, 26),
  DateTime.new(2013, 12, 31),

  DateTime.new(2014, 1, 1),
  DateTime.new(2014, 4, 20),
  DateTime.new(2014, 4, 21),
  DateTime.new(2014, 4, 26),
  DateTime.new(2014, 5, 4),
  DateTime.new(2014, 6, 8),
  DateTime.new(2014, 6, 9),
  DateTime.new(2014, 12, 25),
  DateTime.new(2014, 12, 26),
  DateTime.new(2014, 12, 31),

  DateTime.new(2014, 1, 1),
  DateTime.new(2014, 4, 20),
  DateTime.new(2014, 4, 21),
  DateTime.new(2014, 4, 26),
]

start_time = Date.new(2013, 11, 1)
end_time = Date.new(2015, 02, 28)

CSV.open('export.csv', 'wb', headers: true, force_quotes: true, col_sep: ',') do |csv|
  start_time.upto(end_time).each do |day|
    if day.working_day?
      start_time = WorkingHours.advance_to_working_time(day.beginning_of_day)
      end_time = WorkingHours.return_to_working_time(day.end_of_day)
      csv << [
        start_time.strftime('%Y-%m-%d %H:%M:%S'),
        end_time.strftime('%Y-%m-%d %H:%M:%S'),
        start_time.working_time_until(end_time).seconds / 1.hour
      ]
    end
  end
end
