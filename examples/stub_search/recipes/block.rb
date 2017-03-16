hosts = []
search(:node, 'roles:web') {|n| hosts << n['name'] }
raise 'test failure' unless hosts.length == 1 && hosts[0] == 'example.com'
