
require 'time'
require 'json'
require 'open-uri'

KEY =
  File.read('.abstract_key').strip rescue nil

HOSTS =
  Hash.new do |h, k|
    s = `dig -x #{k} @8.8.8.8`
    m = s.match(/PTR[ \t]+([^ ]+)\./)
    h[k] = m[1].gsub("\n", '') rescue '???'
  end
CITIES =
  Hash.new do |h, k|
    s =
      begin
        fail unless KEY
        URI.open("https://ipgeolocation.abstractapi.com/v1/?api_key=#{KEY}&ip_address=#{k}").read
      rescue => err
p err
        { 'country_code' => 'X', 'city' => 'X' }.to_json
      end
    h[k] =
      begin
        JSON.parse(s)
      rescue
        { 'country_code' => '?', 'city' => '?' }
      end
  end


CR = "[0;0m"
CG = "[32m"
CY = "[33m"
CB = "[1m" # bright


STDIN.each_line do |l|

  l = l.strip

  m = l.match(/^[^ ]+ ([^ ]+) /)

  unless m
    puts if l == ''
    next
  end # so that I can hit Enter to space output...

  a = HOSTS[m[1]]
  c = CITIES[m[1]]
  v = (c['security'] || {})['is_vpn'] ? 'vpn' : nil
  c = [ c['country_code'], c['region_iso_code'], c['city'], v ].compact
  #t = ((c['timezone'] || {})['current_time'] || '').gsub(/:/, '')[0, 4]
  #c = [ c['country_code'], c['region_iso_code'], c['city'], v, t ].compact

  l = l.gsub(/\[[^\]]+\]/) { |x|
    t = x[1..-2].sub(':', ' ')
    t = (Time.parse(t).localtime.to_s rescue t)
    "[#{t}]" }
  l = l
    .gsub(/" (\d{3}) (\d)/) { |x| "\" #{CG}#{x[2, 3]}#{CR} #{x[-2..-1]}" }
    .gsub(/"(GET|HEAD) [^\s]+ HTTP\/[^"]+"/) { |x| "#{CY}#{x}#{CR}" }

  print "#{CB}#{a} #{c.join('|')}#{CR} #{l.split(/\s+/)[1..-1].join(' ')}\n\r"
end

