resource = template('/tmp/resource') do
  action :create
end

resource.run_action(:touch)
