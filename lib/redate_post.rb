
now = Time.now
path = ARGV[0]

content = File.read(path)
  .sub(/---\ndate: '[^']+'\n/m) { |x|
    "---\ndate: '#{now.strftime('%FT%T%:z')}'\n" }

File.open(
  "posts/#{now.strftime('%Y%m%d')}.md", 'wb'
) { |f| f.write(content) }

# do the gittery manually

