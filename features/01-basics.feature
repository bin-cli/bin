Feature: Basics
  https://github.com/bin-cli/bin#how-it-works

  Scenario: A script that is in the bin/ directory can be run without parameters
    Given a script '/project/bin/hello' that outputs "Hello, ${1:-World}! [$#]"
    When I run 'bin hello'
    Then it is successful
    And the output is 'Hello, World! [0]'

  Scenario: Scripts can be run with one parameter passed through
    Given a script '/project/bin/hello' that outputs "Hello, ${1:-World}! [$#]"
    When I run 'bin hello everybody'
    Then it is successful
    And the output is 'Hello, everybody! [1]'

  Scenario: Scripts can be run with multiple parameters passed through
    Given a script '/project/bin/hello' that outputs "Hello, ${1:-World}! [$#]"
    When I run 'bin hello everybody two three four'
    Then it is successful
    And the output is 'Hello, everybody! [4]'

  Scenario: Scripts can be run when in a subdirectory
    Given a script '/project/bin/hello' that outputs 'Hello, World!'
    And the working directory is '/project/subdirectory'
    When I run 'bin hello'
    Then it is successful
    And the output is 'Hello, World!'

  Scenario: Scripts can be run when in a sub-subdirectory
    Given a script '/project/bin/hello' that outputs 'Hello, World!'
    And the working directory is '/project/subdirectory/sub-subdirectory'
    When I run 'bin hello'
    Then it is successful
    And the output is 'Hello, World!'

  Scenario: If you run 'bin' on its own, it will list all available scripts
    Given a script '/project/bin/hello'
    And a script '/project/bin/another'
    When I run 'bin'
    Then it is successful
    And the output is:
      """
      Available commands
      bin another
      bin hello
      """

  @undocumented
  Scenario: The exit code from the command is passed through
    Given a script '/project/bin/fail' with content:
      """sh
      #!/usr/bin/sh
      exit 123
      """
    When I run 'bin fail'
    Then it fails with exit code 123
    And there is no error

  @undocumented
  Scenario: The error from the command is passed through
    Given a script '/project/bin/warn' with content:
      """sh
      #!/usr/bin/sh
      echo "Something is wrong" >&2
      """
    When I run 'bin warn'
    Then the exit code is 0
    And there is no output
    And the error is 'Something is wrong'

  @undocumented
  Scenario: If there are no scripts, it outputs "None found"
    Given an empty directory '/project/bin'
    When I run 'bin'
    Then it is successful
    And the output is:
      """
      Available commands
      None found
      """
