Feature: Aliasing `b` to `bin`
  https://github.com/bin-cli/bin#aliasing-b-to-bin

  # This doesn't work with kcov because $0 is set to 'bin' instead of 'b', though I'm not sure why
  @disable-kcov
  Scenario: The correct executable name is output when using a symlink
    Given a symlink '/usr/bin/b' pointing to 'bin'
    And a script '/project/bin/hello'
    When I run 'b'
    Then it is successful
    And the output is:
      """
      Available commands
      b hello
      """

  Scenario: The executable name can be overridden with environment variable BIN_EXE
    Given a script '/project/bin/hello'
    When I run 'bin --exe b'
    Then it is successful
    And the output is:
      """
      Available commands
      b hello
      """

  Scenario: The executable name for tab completion can be overridden with --exe
    When I run 'bin --completion --exe b'
    Then it is successful
    And the output contains '_bin_b()'
    And the output contains 'complete -F _bin_b b'
