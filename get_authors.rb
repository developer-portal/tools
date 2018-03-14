#!/usr/bin/ruby
mdfiles = File.join("*","**","*.md")
files = Dir.glob(mdfiles)
command = 'git log -5 --pretty=format:"%an;%ae" README.md'
#require 'irb'; binding.irb
puts %x( #{command} )
#do |mdfiles|
