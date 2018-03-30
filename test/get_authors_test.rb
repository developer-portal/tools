require "minitest/autorun"
require "fileutils"

class TestGetAuthors < Minitest::Test
  def setup
    @original_dir = Dir.pwd
    @dir = Dir.mktmpdir 'developer-portal'

    @subdir = File.join(@dir, 'subdir')

    Dir.mkdir @subdir

    FileUtils.cp './test/fixtures/README.md', @subdir

    Dir.chdir @dir


    `git init`

    `git config user.email "you@example.com"`
    `git config user.name "Your Name"`

    `git add .`
    `git commit -m "Initial commit"`
  end

  def teardown
    Dir.chdir @original_dir
    FileUtils.rm_rf @dir
  end

  def test_content
    `#{@original_dir}/get_authors.rb`

    content = File.read(File.join @subdir, 'README.md')
    assert_match %Q|\n{:center: style=\"text-align: center\"}\nAuthors: [Your Name](mailto:you@example.com)\n{:center}|, content
  end

  def test_that_it_writes_authors_once
    skip
  end

  def test_that_it_replaces_authors
    skip
  end

  def test_that_it_finds_md_files
    skip
  end

end
