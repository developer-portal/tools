require "minitest/autorun"
require "fileutils"

require_relative "../get_authors.rb"

class TestGit < Minitest::Test
  def setup
    @original_dir = Dir.pwd
    @dir = Dir.mktmpdir 'developer-portal'

    @subdir = File.join(@dir, 'subdir')

    Dir.mkdir @subdir

    Dir.chdir @dir
  end

  def teardown
    Dir.chdir @original_dir
    FileUtils.rm_rf @dir
  end

  def test_that_git_executes_basic_commands
    assert_match /^git version /, Git.execute('--version')
  end

  def test_that_git_aborts_on_invalid_command
    invalid_command = 'patses'
    err_message = assert_raises(SystemExit) do
      Git.execute invalid_command
    end

    assert_equal "Unknown git command: '#{invalid_command}'", "#{err_message}"
  end
end
