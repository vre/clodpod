# shellcheck shell=bash

Describe 'lib/vm.sh'
    Include lib/common.sh
    Include lib/vm.sh

    Describe 'parse_dir_spec'
        It 'parses name:path'
            When call parse_dir_spec "code:/Users/me/src"
            The output should eq "code|/Users/me/src|0"
        End

        It 'parses name:path:ro as read-only'
            When call parse_dir_spec "code:/Users/me/src:ro"
            The output should eq "code|/Users/me/src|1"
        End

        It 'preserves : in path'
            When call parse_dir_spec "code:/foo:bar/baz"
            The output should eq "code|/foo:bar/baz|0"
        End

        It 'preserves :ro in middle of path'
            When call parse_dir_spec "code:/foo:ro/bar"
            The output should eq "code|/foo:ro/bar|0"
        End

        It 'only strips trailing :ro'
            When call parse_dir_spec "code:/foo:ro:ro"
            The output should eq "code|/foo:ro|1"
        End

        It 'does not match :RO (case sensitive)'
            When call parse_dir_spec "code:/foo:RO"
            The output should eq "code|/foo:RO|0"
        End

        It 'rejects missing colon'
            When call parse_dir_spec "noslash"
            The status should be failure
        End

        It 'rejects empty input'
            When call parse_dir_spec ""
            The status should be failure
        End

        It 'rejects missing name'
            When call parse_dir_spec ":/path"
            The status should be failure
        End

        It 'rejects missing path'
            When call parse_dir_spec "name:"
            The status should be failure
        End

        It 'rejects :ro alone'
            When call parse_dir_spec ":ro"
            The status should be failure
        End
    End
End
