#!/usr/bin/ruby
#   ./statistics.rb <file>
#     Generates table from Google Analytics 'web table' copy-pasted into a file.
#
#   Example:
#     ./statistics.rb stats.txt
#

d = Hash.new
l = nil
ins = -> (z) {
  d[l] ||= Array.new
  d[l].push(z) if d[l].size < 3
}

#d['Statistics for ?/2017'] = %w()

l = '<insert____________date>'
d[l] = %w(Pageviews Unique\ Pageviews Avg.\ Time\ on\ Page)

k = l
l = l.gsub(/./,'=')
d[k].each { |a|
  ins.call(a.gsub(/./,'='))
}

l = 'Total'
ARGF.each_with_index { |b, i|
  b.chomp!
  next if %w[ % ( $ ].include?(b[0]) \
    || b =~ /^\s*$/ \
    || b =~ /^100.00%$/ \

  #p b if i < 30

  b.squeeze(' ').split(' ').each {
    |a|

    if a[0] == '/'
      l=a
    else
      ins.call(a)
    end
  }
}

o = d.map { |x| x.join('|') }
puts `column -ts '|' <<< "#{o.join("\n")}"`
