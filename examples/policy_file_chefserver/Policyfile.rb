name 'fake_policy_to_show_chef_server_works'

default_source :chef_server, 'http://localhost:8889'

run_list 'policy_file_chefserver'

cookbook 'policy_file_chefserver', path: '.'
