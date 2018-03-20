#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

def md_mailto(a, e)
  "[#{a}](#{e})"
end

def md_center(text)
  '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
end

files = Dir.glob File.join('*', '**', '*.md')

files.each do |f|
  author_mail = {}
  author_md = []
  command = 'git log -5 --pretty=format:"%an;%ae" '
  command_out = %x(#{command}#{f}).split(/[;\n]/)
  author_mail = command_out.each_slice(2).to_h.sort

  author_mail.each do |a, e|
    author_md << md_mailto(a, e)
  end

  output = author_md.join ', '
  output = "Authors: #{output}"
  output = md_center output

  File.open(f, 'a') do |file|
    file.write "\n#{output}"
  end
end
