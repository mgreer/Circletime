desc "This task is called by the Heroku scheduler add-on"
task :close_open_jobs => :environment do
    puts "Closing open jobs..."
    Job.close_open_jobs
    puts "done."
end
