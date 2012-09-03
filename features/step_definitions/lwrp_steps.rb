Given 'a Chef cookbook with a LWRP and a recipe that declares it' do
  cookbook_with_lwrp
end

Given 'the recipe has a spec example that expects the LWRP to be run' do
  spec_expects_lwrp_to_greet
end

Then 'the LWRP will have been executed' do
  # checked in the spec
end
