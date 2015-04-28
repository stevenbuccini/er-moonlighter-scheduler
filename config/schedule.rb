# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.day, at: '4:30 am' do
  # Every day, clean up completed shifts.
  # For each doctor who completes a shift, this Cronjob will update
  # their `last_completed_shift` field.
  runner "Shift.delete_completed_shifts"
  # We need to figure out how we want to notify the doctors about whether or not
  # they are in denial.

end