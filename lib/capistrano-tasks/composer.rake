namespace :composer do

	desc "Run composer command"
	task :run, :command do |_t, args|
		ask (:cmd)
		cmd = args[:command] || fetch(:cmd)

		on roles(:all) do
			within release_path do
				execute :composer, "#{cmd}" ,*args.extras
			end
		end

		Rake::Task["composer:run"].reenable
	end
	
	desc "run composer install"
	task :install do
		invoke "composer:run", "install", fetch(:install_flags)
	end

	desc "run composer dump-autoload"
	task :autoload do
		invoke "composer:run", :dumpautoload, fetch(:dumpautoload_flags)
	end

	desc "run composer update"
	task :update do
		invoke "composer:run", "update"
	end

	after "composer:run", :dump_autoload do
		invoke "composer:dumpautoload"
	end
	
end

namespace :load do
	task :defaults do
		set :code, "php"
		set :dumpautoload_flags,  "-o"
		set :install_flags, "--no-scripts"
	end
end
