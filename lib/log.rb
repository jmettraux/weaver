
require 'time'

CACHE =
  Hash.new do |h, k|
    s = `dig -x #{k}`
    m = s.match(/PTR[ \t]+([^ ]+)\./)
    h[k] = m[1] rescue '???'
  end

STDIN.readlines.each do |l|
  l = l.strip
  m = l.match(/^[^ ]+ ([^ ]+) /)
  a = CACHE[m[1]]
  l = l.gsub(/\[[^\]]+\]/) { |x|
    '[' + Time.parse(x[1..-2].sub(':', ' ')).localtime.to_s + ']' }
  puts "#{a} #{l.split(/\s+/)[1..-1].join(' ')}"
end

