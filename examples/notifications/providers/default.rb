action(:create) do
  new_resource.updated_by_last_action(new_resource.name == 'update')
end
