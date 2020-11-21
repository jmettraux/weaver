
require 'time'

CACHE =
  Hash.new do |h, k|
    s = `dig -x #{k}`
    m = s.match(/PTR[ \t]+([^ ]+)\./)
    h[k] = m[1] rescue '???'
  end

out = []

STDIN.readlines.each do |l|
  l = l.strip
  m = l.match(/^[^ ]+ ([^ ]+) /)
  a = CACHE[m[1]]
  l = l.gsub(/\[[^\]]+\]/) { |x|
    '[' + Time.parse(x[1..-2].sub(':', ' ')).localtime.to_s + ']' }
  out << "#{a} #{l.split(/\s+/)[1..-1].join(' ')}"
end

sta = out[0].match(/\[(.+)\]/)[1].gsub(/[-:]/, '').gsub(/[^0-9]/, '_')[0, 13]
edn = out[-1].match(/\[(.+)\]/)[1].gsub(/[-:]/, '').gsub(/[^0-9]/, '_')[0, 13]

fn = "tmp/weaver__#{sta}__#{edn}.log"

File.open(fn, 'wb') do |f|
  out.each { |l| f.puts(l) }
end

puts "#{File.exist?(fn) ? 'over' : ''}wrote #{fn}"

