Feature: The script matcher
  Background:
    * I am using the "script" cookbook

  Scenario Outline: Running specs
    * I successfully run `rspec spec/<Matcher>_spec.rb`
    * the output should contain "0 failures"
  Examples:
    | Matcher    |
    | run_bash   |
    | run_csh    |
    | run_perl   |
    | run_python |
    | run_ksh    |
    | run_ruby   |
    | run_script |
