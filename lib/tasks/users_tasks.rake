namespace :users do 
	desc 'Task for recreate database in one command'
	task :recreateDB => ["db:drop", "db:create", "db:migrate"]
end
