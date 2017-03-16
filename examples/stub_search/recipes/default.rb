hosts = search(:node, 'name:example.com')
raise 'test failure' unless hosts.length == 1 && hosts[0]['name'] == 'example.com'
