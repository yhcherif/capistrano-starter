namespace :laravel do
	desc "Laravel artisan command"
	task :artisan, :command do |_t, args|
		ask (:cmd)
		cmd = args[:command] || fetch(:cmd)

		on roles(fetch(:allowed_roles)) do 
			within release_path do
				execute :php, :artisan, "#{cmd}", fetch(:laravel_artisan_flags)
			end
		end

		Rake::Task["laravel:artisan"].reenable
	end

	desc "generate a key for the application"
	task :key do
		invoke "laravel:artisan", "key:generate"
	end

	desc "migrate to database"
	task :migrate do
		invoke "laravel:artisan", "migrate"
	end

	desc "seed the database"
	task :seed do
		invoke "laravel:artisan", "db:seed"
	end

	desc "optimize the application"
	task :optimize do
		invoke "laravel:artisan", "view:clear"
		invoke "laravel:artisan", "cache:clear"
		invoke "laravel:artisan", "optimize"
	end

	desc "clear the application cache"
	task :clear do
		invoke "laravel:artisan", "view:clear"
		invoke "laravel:artisan", "cache:clear"
	end

	desc "Apply posix roles"
	task :posix do
		on roles(fetch(:allowed_roles)) do
			fetch(:laravel_posix_folders).each do |folder|
				execute :sudo, :chmod, "-R", "777", "#{release_path}#{folder}"
			end
		end
	end


	desc "enable maintenance mode"
	task :down do
		invoke "laravel:artisan", "down"
	end

	desc "disable maintenance mode"
	task :up do
		invoke "laravel:artisan", "up"
	end


	desc "Reset database"
	task :reset do
		invoke "laravel:artisan", "migrate:reset", "--force"
	end


	desc "Generate laravel env file"
	task :env do
		on roles(fetch(:allowed_roles)) do
			upload! fetch(:dotenv), "#{shared_path}/#{fetch(:dotenv)}"
			execute :chmod, "755", "#{shared_path}/#{fetch(:dotenv)}"
		end
	end

end

namespace :deploy do
	after 'deploy:check:make_linked_dirs', :create_env do
		if fetch(:code) == "laravel"
			invoke "laravel:env"
		end
	end
end