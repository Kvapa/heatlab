# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
set :environment, 'development'
set :output, { error: 'error.log', standard: 'cron.log' }
# Example:
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
every :friday, at: "11:59 AM" do
 runner "UsersController.birthdays"
end

# Learn more: http://github.com/javan/whenever
