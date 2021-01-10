
require 'redcarpet'
require 'scorn'
require 'nokogiri'

EXCLUSION_LIST = %w[
  https://www.drivethrurpg.com
  https://www.youtube.com
  https://www.patreon.com
  https://www.kickstarter.com ]


dry = ! ARGV.include?('--not-dry')
post = ENV['POST']

last_post = post || Dir['posts/*.md'].sort.last


class LinkRender < Redcarpet::Render::Base
  attr_reader :links
  def initialize; super; @links = []; end
  def link(link, title, content); @links << [ link, title, content ]; ''; end
end

lrender = LinkRender.new
Redcarpet::Markdown.new(lrender, {}).render(File.read(last_post))

links = lrender.links
  .select { |href, _, _| ! EXCLUSION_LIST.find { |s| href.start_with?(s) } }

links.each do |link, title, content|
  puts "---"
  puts "link: #{link}"
  doc = Nokogiri::HTML(Scorn.get(link))
  #doc.css('link[rel]').each do |link|
  [
    doc.css('link[rel="webmention"]') +
    doc.css('link[rel="http://webmention.org/"]')
  ].each do |link|
    href = link[:href]
    puts "webmention: #{href}"
  end
end

