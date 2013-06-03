@not_implemented_minitest
Feature: Evaluate resource guards

  In order to determine if my guard logic is correct
  As a cookbook developer
  I want to be able to evaluate not_if and only_if conditionals

  Scenario Outline: Resource with a ruby guard
    Given a recipe that declares a resource with a <guard_type> ruby guard that returns <guard_result>
      And the recipe has a spec example with guards <guards_enabled> that expects the resource to <expected>
     When the guard example is <success> run
     Then the resource will not have been created
  Examples:
    | guard_type | guard_result | guards_enabled | expected        | success        |
    | only_if    | true         | unspecified    | be declared     | successfully   |
    | only_if    | false        | unspecified    | be declared     | successfully   |
    | only_if    | true         | disabled       | be declared     | successfully   |
    | only_if    | false        | disabled       | be declared     | successfully   |
    | only_if    | true         | enabled        | be declared     | successfully   |
    | only_if    | false        | enabled        | be declared     | unsuccessfully |
    | only_if    | true         | enabled        | not be declared | unsuccessfully |
    | only_if    | false        | enabled        | not be declared | successfully   |
    | not_if     | true         | unspecified    | be declared     | successfully   |
    | not_if     | false        | unspecified    | be declared     | successfully   |
    | not_if     | true         | disabled       | be declared     | successfully   |
    | not_if     | false        | disabled       | be declared     | successfully   |
    | not_if     | true         | enabled        | be declared     | unsuccessfully |
    | not_if     | false        | enabled        | be declared     | successfully   |
    | not_if     | true         | enabled        | not be declared | successfully   |
    | not_if     | false        | enabled        | not be declared | unsuccessfully |

  Scenario Outline: LWRP Resource with a ruby guard
    Given a recipe that declares a lwrp resource with a <guard_type> ruby guard that returns <guard_result>
      And the recipe has a spec example with guards <guards_enabled> that expects the lwrp resource to <expected>
     When the guard example is <success> run
     Then the resource will not have been created
  Examples:
    | guard_type | guard_result | guards_enabled | expected        | success        |
    | only_if    | true         | unspecified    | be declared     | successfully   |
    | only_if    | false        | unspecified    | be declared     | successfully   |
    | only_if    | true         | disabled       | be declared     | successfully   |
    | only_if    | false        | disabled       | be declared     | successfully   |
    | only_if    | true         | enabled        | be declared     | successfully   |
    | only_if    | false        | enabled        | be declared     | unsuccessfully |
    | only_if    | true         | enabled        | not be declared | unsuccessfully |
    | only_if    | false        | enabled        | not be declared | successfully   |
    | not_if     | true         | unspecified    | be declared     | successfully   |
    | not_if     | false        | unspecified    | be declared     | successfully   |
    | not_if     | true         | disabled       | be declared     | successfully   |
    | not_if     | false        | disabled       | be declared     | successfully   |
    | not_if     | true         | enabled        | be declared     | unsuccessfully |
    | not_if     | false        | enabled        | be declared     | successfully   |
    | not_if     | true         | enabled        | not be declared | successfully   |
    | not_if     | false        | enabled        | not be declared | unsuccessfully |

  Scenario Outline: Shell guards without stubbing
    Given a recipe that declares a resource with a <guard_type> shell guard test -f /etc/passwd
      And a spec example with guards enabled without stubbing that expects the resource to <expected>
     When the guard example is unsuccessfully run with stub error
     Then the resource will not have been created
  Examples:
    | guard_type | expected        |
    | only_if    | be declared     |
    | not_if     | not be declared |

  Scenario Outline: Stub shell guards
    Given a recipe that declares a resource with a <guard_type> shell guard <guard>
      And a spec example with guards <enabled> that stubs <stub> to return <result> and expects the resource to <expected>
     When the guard example is <success> run
     Then the resource will not have been created
  Examples:
    | guard_type | enabled     | guard               | stub                  | result | expected        | success        |
    | only_if    | unspecified | test -f /etc/passwd |                       |        | be declared     | successfully   |
    | only_if    | disabled    | test -f /etc/passwd |                       |        | be declared     | successfully   |
    | only_if    | enabled     | test -f /etc/passwd | 'test -f /etc/passwd' | false  | not be declared | successfully   |
    | only_if    | enabled     | test -f /etc/passwd | 'test -f /etc/passwd' | true   | be declared     | successfully   |
    | only_if    | enabled     | test -f /etc/passwd | /test/                | false  | not be declared | successfully   |
    | only_if    | enabled     | test -f /etc/passwd | /test/                | true   | be declared     | successfully   |
    | only_if    | enabled     | cat foo \| grep bar | /grep/                | true   | be declared     | successfully   |
    | not_if     | unspecified | test -f /etc/passwd |                       |        | be declared     | successfully   |
    | not_if     | disabled    | test -f /etc/passwd |                       |        | be declared     | successfully   |
    | not_if     | enabled     | test -f /etc/passwd | 'test -f /etc/passwd' | false  | be declared     | successfully   |
    | not_if     | enabled     | test -f /etc/passwd | 'test -f /etc/passwd' | true   | not be declared | successfully   |
    | not_if     | enabled     | test -f /etc/passwd | /test/                | false  | be declared     | successfully   |
    | not_if     | enabled     | test -f /etc/passwd | /test/                | true   | not be declared | successfully   |
