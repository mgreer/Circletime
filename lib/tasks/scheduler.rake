task :close_open_jobs => :environment do
    JobsController.close_open_jobs
end