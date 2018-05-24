#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

# Git::Log parses output passed from Git#log and creates a hash with author as a key and email as value
module Git
  class Log
    # We are expecting output from "git log" command
    def initialize(log)
      @log = log
    end

    # Iterate through each line in the log
    # filter out whitespace characters, split the line by semicolon
    # assign the returned pair (i.e. author and email) to author and email variables
    # then create hash with author as key and email as value and return it.
    def author_email
      author_email = Hash.new
      @log.each_line do |line|
        author, mail = line.strip.split(';')

        author_email[author] = mail unless author_email.key?(author)
      end
      author_email
    end

    # To ensure log will be text when we want
    def to_s
      @log
    end
  end

  # Take a git command and execute
  # Abort if command didn't execute successfully
  # then return output of the command.
  def self.execute(command)
    output = `git #{command}`

    abort "Unknown git command: '#{command}'" unless $?.success?

    return output
  end

  # Create instance of Git::Log and pass it output from git log command
  # return 5 last authors of a particular file
  # %an returns author, semicolon for effortless parsing, %ae return email of author
  def self.log(file)
    Log.new(execute("log -5 --pretty=format:'%an;%ae' #{file}"))
  end
end

module Markdown
  def self.mailto(a, e)
    "[#{a}](mailto:{{ '#{e}' | encode_email }})"
  end

  def self.center(text)
    '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
  end
end

def main
  files = Dir.glob File.join('*', '**', '*.md')

  files.each do |f|
    author_md = Git.log(f).author_email
    author_md = author_md.sort
    author_md = author_md.map { |a, e| Markdown.mailto(a, e) }

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
