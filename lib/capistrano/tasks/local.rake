namespace :local do

	namespace :dns do

		desc "Add new record in local host file"
		task :add do
			rhost = nil
		  	on roles(fetch(:allowed_roles)) do
		  		rhost = host
		  	end
			on(:local) do
				if test "[ -w #{fetch(:host_path)} ]"
					set :pointed_domain, ask("Domain name: ", "#{fetch(:application).downcase}.dev")
					execute :echo, "#{rhost} #{fetch(:pointed_domain)}", ">>", fetch(:host_path)
					info "new dns record in hosts file : #{fetch(:pointed_domain)} => #{rhost}"
					next
				end
				warn "[Skip] Cannot add dns record. Make sure your host file is writable by the current user"
			end
		end
	end

end


namespace :load do
	task :defaults do
		set :host_path, "/etc/hosts"
	end
end