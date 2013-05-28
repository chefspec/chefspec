Given /^a recipe that declares a (lwrp )?resource with a (only_if|not_if) ruby guard that returns (true|false)$/ do |lwrp, guard_type, guard_result|
  guard_attribute = "#{guard_type}{ #{guard_result} }"
  if lwrp
    cookbook_with_lwrp(guard_attribute)
  else
    recipe_creates_file(guard_attribute)
  end
end

Given /^the recipe has a spec example with guards (unspecified|enabled|disabled) that expects the (lwrp )?resource to (be declared|not be declared)$/ do |guards_enabled, lwrp, be_declared|
  expectation = be_declared == 'be declared' ? 'to' : 'not_to'
  constructor_args = case guards_enabled
                       when 'unspecified' then []
                       when 'disabled' then [[:evaluate_guards, false]]
                       when 'enabled' then [[:evaluate_guards, true]]
                     end
  if lwrp
    spec_expects_lwrp_to_greet(constructor_args, expectation)
  else
    spec_expects_file_with_args(constructor_args, expectation, be_declared)
  end
end

When 'the guard example is unsuccessfully run' do
  run_examples_unsuccessfully ', 1 failure'
end

Then 'the resource will not have been created' do

end
