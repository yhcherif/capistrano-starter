namespace :local do
	desc "Add new record in local host file"
	task 'dns:add' do
		unless test "[ -w /etc/hosts ]"
			rhost = nil
		  	on roles(:all) do
		  		rhost = host
		  	end
			on(:local) do
				set :pointed_domain, ask("Domain name: ", "#{fetch(:application).downcase}.dev")
				execute :echo, "#{rhost} #{fetch(:pointed_domain)}", ">>", "/etc/hosts"
				info "new dns record in hosts file : #{fetch(:pointed_domain)} => #{rhost}"
			end
			next
		end
	end
end