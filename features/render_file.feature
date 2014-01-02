Feature: The render_file matcher
  Background:
    * I am using the "render_file" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher |
    | default |
  @not_chef_11_0_0
  @not_chef_11_2_0
  @not_chef_11_4_4
  Examples:
    | Matcher          |
    | template_helpers |
