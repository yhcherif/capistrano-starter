require "erb"
namespace :server do


	desc "Upload a file on remote server"
	task :upload do
		on roles(fetch(:allowed_roles)) do
			set :source, ask("source path :", "/tmp/example.txt")
			set :dest, ask("destination path on remote :", "/home/user/deployed.md")
			upload! fetch(:source), fetch(:dest)
		end
		
	end


	namespace :nginx do
		desc "Create nginx configuration file"
		task :conf do
			on roles(fetch(:allowed_roles)) do
				# Set variables
				set :server_name, ask("Server name : ", "www.exampsle.com")
				set :root_dir, ask("root dir : ", "#{release_path}/public")
				set :config_file, ask("config file name : ", "app_name.config")
				set :app_type, fetch(:code)
				@server_name = fetch(:server_name)
				@root_dir = fetch(:root_dir)
				temp_path = "/tmp/tmp_#{fetch(:config_file)}"

				config_path = "/etc/nginx/sites-available/#{fetch(:config_file)}"


				# generate config file from template
				file_path = File.expand_path("../../templates/nginx.conf.erb", __FILE__)
				template = ERB.new File.read(file_path), nil, '%'
				# template = ERB.new File.read("../../templates/nginx.conf.erb"), nil, '%'
				render = StringIO.new template.result(binding)

				# Create nginx config file
				info "Generationg nginx configuration file #{config_path}"
				upload! render, temp_path
				execute :sudo, :mv, "#{temp_path}", "#{config_path}"
				# execute :sudo, :echo, "''' #{@render} '''", ">", "#{@config_path}"


				# Create Symbolyc link for in sites-enabled folder
				info "Linking #{config_path} to /etc/nginx/sites-enabled/#{fetch(:config_file)}"
				execute :sudo, :ln, "-s", "#{config_path}", "/etc/nginx/sites-enabled/#{fetch(:config_file)}"

				# Restart Nginx service
				info "Restarting nginx service"
				execute :sudo, :service, :nginx, :restart
				
			end
		end
	end


	namespace :mysql do
		
		desc "Drop mysql database"
		task :drop do
			on roles(fetch(:allowed_roles)) do
				set :db_name, ask("Database name :", "app")
				set :mysql_pass, ask("Mysql #{fetch(:mysql_user)} password :", "", echo: false)
				
				execute :mysql, "-u", "#{fetch(:mysql_user)}", "-p#{fetch(:mysql_pass)}", "-e", "' DROP DATABASE `#{fetch(:db_name)}`;'"
				
				info "#{fetch(:db_name)} succesfully created"
			end
		end


		desc "Create mysql database"
		task :create do
			on roles(fetch(:allowed_roles)) do
				set :db_name, ask("Database name :", "app")
				set :mysql_pass, ask("Mysql #{fetch(:mysql_user)} password :", "" ,echo: false)
				execute :mysql, "-u", "#{fetch(:mysql_user)}", "-p#{fetch(:mysql_pass)}", "-e", "' CREATE DATABASE IF NOT EXISTS `#{fetch(:db_name)}` DEFAULT CHARACTER SET `utf8`;'"
				info "#{fetch(:db_name)} succesfully deleted"
			end
		end
	end
end


namespace :load do
	task :defaults do
		set :mysql_user, "root"
		set :allowed_roles, :all
		set :user, "deploy"
		set :rails_env, "production"
		set :laravel_posix_folders, [
			"/storage", "/bootstrap/cache", "/public"
		]
		set :dotenv, ".env"
		# set :laravel_artisan_flags, "--force"
	end
end