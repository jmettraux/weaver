
require 'redcarpet'
require 'scorn'
require 'nokogiri'

require 'extensions'

EXCLUSION_LIST = %{
  #https://amzn.to/
  #https://www.drivethrurpg.com
  #https://www.youtube.com
  https://www.patreon.com
    # goes 403 it seems...
  #https://www.kickstarter.com
  .wikipedia.org
  grumpywizard.home.blog
  .blogspot.com/
  /Blogosphere
  /series/amplifying-the-blogosphere/
  .tumblr.com/
  .wordpress.com/
      }
    .strip
    .split("\n")
    .collect(&:strip)
    .select { |e| e[0, 1] != '#' }

dry = ! ARGV.include?('--not-dry')
post = ENV['POST'] || Dir['posts/*.md'].sort.last
date = post.match(/(\d{8})/)[1]
mdown = File.read(post)
title = mdown.match(/^## ([^\n\r]+)/)[1]
_title = title.to_safe_string
uri = "https://weaver.skepti.ch/#{date}.html?f=wm&t=#{_title}"

seen = []


class LinkRender < Redcarpet::Render::Base
  attr_reader :links
  def initialize; super; @links = []; end
  def link(link, title, content); @links << [ link, title, content ]; ''; end
end

lrender = LinkRender.new
Redcarpet::Markdown.new(lrender, {}).render(mdown)

links = lrender.links
  .select { |href, _, _|
    href.start_with?('http') &&
    ! EXCLUSION_LIST.find { |s| href.index(s) } }

links.each do |link, title, content|

  m = link.match(/^(.+)([?&#]eow)$/)
  link = m[1] if m

  next if seen.include?(link)

  puts "---"
  puts "link: #{link}"

  res = link.match?(/^https?:\/\//) ? Scorn.get(link) : nil
  #pp res._response._headers # <-- the webmention link might hide there!

  puts "  response: /!\\ #{res._response._c} !!!" if res._response._c != 200

  next unless res && res._response._c == 200

  doc = Nokogiri::HTML(res)

  (
    doc.css('link[rel="webmention"]') +
    doc.css('link[rel="http://webmention.org/"]')
  )
    .take(1)
    .each { |wml|

      href = wml[:href]
      puts "  webmention: #{href}"

      puts "    post to: #{href}"
      puts "    source: #{uri}"
      puts "    target: #{link}"

      if dry
        # do nothing
      else
        r =
          File.open('ping_debug.txt', 'wb') do |df|
            Scorn.post(href, data: { source: uri, target: link }, debug: df)
          end
        File.open('ping_out.txt', 'wb') { |rf| rf.write(r) }
        res = r._response
        p [ res._c, res._sta ]
        pp res._headers
      end }

  seen << link
end

