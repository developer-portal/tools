#!/usr/bin/ruby
# This script gets last 5 authors of a file and writes them at the end of the file.

def md_mailto(a, e)
  "[#{a}](mailto:#{e})"
end

def md_center(text)
  '{:center: style="text-align: center"}' + "\n#{text}\n{:center}"
end

def arr_to_hash(array)
  sliced_array = array.each_slice(2).sort
  Hash[sliced_array]
end

files = Dir.glob File.join('*', '**', '*.md')

files.each do |f|
  author_mail = {}
  author_md = []
  command = 'git log -5 --pretty=format:"%an;%ae" '
  command_out = %x(#{command}#{f}).split(/[;\n]/)
  author_mail = arr_to_hash command_out

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
