Given 'a Chef cookbook with a LWRP and a recipe that declares it' do
  cookbook_with_lwrp
end

Given 'the recipe has a spec example that expects the lwrp to be run' do
  spec_expects_lwrp_to_greet
end

Then 'the lwrp will have been executed' do
  #assert partial_output "Hello Foobar!", all_outout
end
