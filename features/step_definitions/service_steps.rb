Given 'a Chef cookbook with a recipe that starts a service' do
  recipe_starts_service
end

Given 'a Chef cookbook with a recipe that starts a service and enables it to start on boot' do
  recipe_starts_and_enables_service
end

Given 'a Chef cookbook with a recipe that stops a service' do
  recipe_stops_service
end

Given 'a Chef cookbook with a recipe that restarts a service' do
  recipe_restarts_service
end

Given 'a Chef cookbook with a recipe that signals a service to reload' do
  recipe_reloads_service
end

Given 'the recipe has a spec example that expects the service to be started' do
  spec_expects_service_action(:start)
end

Given 'the recipe has a spec example that expects the service to be started and enabled' do
  spec_expects_service_to_be_started_and_enabled
end

Given 'the recipe has a spec example that expects the service to be stopped' do
  spec_expects_service_action(:stop)
end

Given 'the recipe has a spec example that expects the service to be restarted' do
  spec_expects_service_action(:restart)
end

Given 'the recipe has a spec example that expects the service to be reloaded' do
  spec_expects_service_action(:reload)
end

Then /^the service will not have been started$/ do
  # service start would fail
end

Then /^the service will not have been stopped$/ do
  # service stop would fail
end

Then /^the service will not have been restarted$/ do
  # service restart would fail
end

Then /^the service will not have been reloaded$/ do
  # service reload would fail
end
