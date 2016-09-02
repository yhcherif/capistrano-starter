namespace :composer do

	desc "Run composer command"
	task :run, :command do |_t, args|
		ask (:cmd)
		cmd = args[:command] || fetch(:cmd)

		on roles(fetch(:allowed_roles)) do
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
		invoke "composer:run", "update", fetch(:install_flags)
	end

	# Invoke laravel commands
	after "composer:autoload", :optimize do
		invoke "laravel:posix"
		invoke "laravel:migrate"
		invoke "laravel:optimize"
	end



	# Ivoke composer task after deploy

	after :install, :dump_autoload do
		invoke "composer:autoload"
	end

	after "composer:update", :dump_autoload_update do
		invoke "composer:autoload"
	end
end

namespace :load do
	task :defaults do
		set :code, "php"
		set :dumpautoload_flags,  "-o"
		set :install_flags, "--no-scripts"
	end
end


namespace :deploy do
	after "deploy:published", :composer_install do
		if fetch(:code) == "laravel"
			invoke "composer:install"
		end
	end
end