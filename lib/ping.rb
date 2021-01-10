
require 'redcarpet'
require 'scorn'
require 'nokogiri'

EXCLUSION_LIST = %w[
  https://www.drivethrurpg.com
  https://www.youtube.com
  https://www.patreon.com
  https://www.kickstarter.com ]


dry = ! ARGV.include?('--not-dry')
post = ENV['POST'] || Dir['posts/*.md'].sort.last
uri = "https://weaver.skepti.ch/#{post.match(/(\d{8})/)[1]}.html?t=xxx"


class LinkRender < Redcarpet::Render::Base
  attr_reader :links
  def initialize; super; @links = []; end
  def link(link, title, content); @links << [ link, title, content ]; ''; end
end

lrender = LinkRender.new
Redcarpet::Markdown.new(lrender, {}).render(File.read(post))

links = lrender.links
  .select { |href, _, _| ! EXCLUSION_LIST.find { |s| href.start_with?(s) } }

links.each do |link, title, content|

  puts "---"
  puts "link: #{link}"

  res = Scorn.get(link)
  #pp res._response._headers
  next unless res._response._c == 200

  doc = Nokogiri::HTML(res)

  (
    doc.css('link[rel="webmention"]') +
    doc.css('link[rel="http://webmention.org/"]')
  ).each do |wml|

    href = wml[:href]
    puts "  webmention: #{href}"

    if dry
      puts "    post to: #{href}"
      puts "    source: #{uri}"
      puts "    target: #{link}"
    else
    end
  end
end


#Scorn.post(
#  'https://webmention.io/weaver.skepti.ch/webmention',
#  data: {
#    source: 'http://foo.operati.ca/test.html',
#    target: 'https://weaver.skepti.ch/20210109.html?f=foo' },
#  debug: $stderr)
