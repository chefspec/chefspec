name 'fake_policy_to_show_supermarket_works'

default_source :supermarket

run_list 'policy_file'

cookbook 'policy_file', path: '.'
