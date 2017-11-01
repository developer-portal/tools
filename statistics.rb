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

d['Statistics for ?/2017'] = %w()

l = '<insert_____________date>'
d[l] = %w(Pageviews Unique\ Pageviews Avg.\ Time\ on\ Page)

k = l
l = l.gsub(/./,'=')
d[k].each { |a|
  ins.call(a.gsub(/./,'='))
}

l = 'Total'
ARGF.each { |b| 
  next if b[0] == '%'
  b.squeeze(' ').split(' ').each { |a|
    if a[0] == '/' ; l=a else ins.call(a) end
  }
}

o = d.map { |x| x.join('|') }
puts `column -ts '|' <<< "#{o.join("\n  ")}"`
