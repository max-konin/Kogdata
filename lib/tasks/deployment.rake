namespace :deployment do
  task :setup => :environment do
    ActiveRecord::Base.establish_connection('production')
    Rake::Task['db:migrate'].invoke
    Rake::Task['assets:clean'].invoke
    Rake::Task['assets:precompile'].invoke
  end

end
