#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

# Get last 5 authors of a file and their email
module Git
  class Log
    def initialize(log)
      @log = log
    end

    def author_email
      author_email = Hash.new
      @log.each_line do |line|
        author, mail = line.strip.split(';')

        author_email[author] = mail unless author_email.key?(author)
      end
      author_email
    end

    def to_s
      @log
    end
  end

  def self.log(file)
    Log.new(`git log -5 --pretty=format:"%an;%ae" #{file}`)
  end
end

module Markdown
  def self.mailto(a, e)
    "[#{a}](mailto:#{e})"
  end

  def self.center(text)
    '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
  end
end

def main
  files = Dir.glob File.join('*', '**', '*.md')

  files.each do |f|
    author_md = Git.log(f).author_email.sort.map { |a, e| Markdown.mailto(a, e) }

    output = author_md.join ', '
    output = "Authors: #{output}"
    output = Markdown.center output

    File.open(f, 'a') do |file|
      file.write "\n#{output}"
    end
  end
end

if File.identical?(__FILE__, $0)
  main
end
