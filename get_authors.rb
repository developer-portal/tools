#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

# Get last 5 authors of a file and their email
def get_authors(file)
  `git log -5 --pretty=format:"%an;%ae" #{file}`.split(/[;\n]/)
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
    author_mail = get_authors(f).each_slice(2).to_h.sort

    author_md = author_mail.collect { |a, e| Markdown.mailto(a, e) }

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
