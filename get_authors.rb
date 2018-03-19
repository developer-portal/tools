#!/usr/bin/ruby
# This script gets last 5 authors on a file and writes them on the end.
mdfiles = File.join("*","**","*.md")
files = Dir.glob(mdfiles)
def create_md (a,e)
  "[#{a}](#{e})"
end
files.each do |f|
  author_mail = {}
  author_md = []
  command = ( 'git log -5 --pretty=format:"%an;%ae" ' )
  commandOut = %x( #{command}#{f} ).split(/[;\n]/)
  author_mail = commandOut.each_slice(2).to_h.sort
  author_mail.each do |a,e|
    author = create_md(a,e)
    author_md << author
  end
  output = author_md.join(", ")
  File.open(f, "a") do |file|
    file.write("\nAuthors: #{output}")
  end
end
