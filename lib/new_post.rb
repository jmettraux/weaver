
n = Time.now
fn = nil
  #
loop do
  fn = "posts/#{n.strftime('%Y%m%d')}.md"
  break unless File.exist?(fn)
  n = n + 24 * 3600
end


File.open(fn, 'ab') do |f|
  f.print(%{
---
date: '#{n.strftime('%FT%T%:z')}'
tags: [ 'en' ]
---

## title

Blah blah blah



<!-- 17 6 -->
  }.strip + "\n")
end

puts ". prepared #{fn}"

