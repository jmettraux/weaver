

require 'pp'
require 'yaml'
require 'nokogiri'
require 'redcarpet'
require 'redcarpet/render_strip'

require 'extensions'
require 'html_renderer'


class String

  def substitute(vars)

    self.gsub(/\$\{[^\}]+\}/) do |dollar|

      d = dollar[2..-2]

      r = (vars.instance_eval('self.' + d) rescue nil)
      next r.to_s if r

      r = (vars.instance_eval(d) rescue nil)
      next r.to_s if r

      ''
    end
  end
end

class Hash

  def partial(path) # helper

    File.read(File.join('partials/', path)).substitute(self)
  end

  def method_missing(key, *args, &block)

    return super if args.any? || block

    self[key.to_s] || self[key]
  end
end

class Array

  def method_missing(key, *args, &block)

    return super if args.any? || block

    i = key.to_s.to_i
    return super if i.to_s != key.to_s

    self[i]
  end
end

class Time

  def to_www_s

    strftime('%FT%T%z')
  end

  def to_utc_www_s

    dup.utc.strftime('%FT%TZ')
  end
end

module Blog

  @html_renderer =
    Redcarpet::Markdown.new(
      HtmlRenderer.new({}),
      tables: false, footnotes: true)
  @text_renderer =
    Redcarpet::Markdown.new(
      Redcarpet::Render::StripDown.new(),
      {})

  def self.md_render(s, opts={})

    renderer = opts[:mode] == 'text' ? @text_renderer : @html_renderer

    hr = renderer.renderer
    hr.footnote_prefix = opts[:footnote_prefix] \
      if hr.respond_to?(:footnote_prefix=)

    r = renderer.render(s)

    r = r
      .gsub(/\s*<\/?blockquote>\s*/, '"')
      .gsub(/\s*<\/?[^>]+>/, ' ') \
        if opts[:index] == true

    r
  end

  def self.html_to_atom_xhtml(s)

    doc = Nokogiri::HTML(s)

    doc.css('.no-atom').each(&:remove)

    %w[ script style ]
      .each { |tag| doc.css(tag).each(&:remove) }

    doc.css('audio').each { |e| e.remove_attribute('controls') }
    doc.css('img').each { |e| e.remove_attribute('style') }

    doc.at_css('body').to_xhtml[6..-8]
  end

  def self.load_post(path)

    content = File.read(path).strip
    m = content.match(/\A---\n(.*)\n---\n(.*)\z/m)

    vars = merge_vars(m ? m[1] : {})
    content = m ? m[2].strip : content

    m = content.match(/\A## ([^\n]+)/)

    vars['title'] ||= m ? m[1] : ''
    vars['_title'] = vars['title'].to_safe_string
    vars['id'] = File.basename(path, '.md')
    vars['tags'] ||= []

    vars['uri'] =
      File.join(
        vars['blog']['uri'],
        "#{vars['id']}.html?t=#{vars['_title']}")

    vars['_id'] = vars['id']
    if m = vars['id'].match(/\A(\d{4})(\d{2})(\d{2})\z/)
      vars['_id'] = "#{m[1]}-#{m[2]}-#{m[3]}"
    end

    m = content.match(/src="([^"]+\.(?:jpg|png|gif|webp))"/)
    vars['image'] = m[1] if m

    content = rework_text(content)

    [ vars, content ]
  end

  def self.merge_vars(o)

    (YAML.load(File.read('blog.yaml')) rescue {})
      .merge(o.is_a?(Hash) ? o : YAML.load(o))
      .tap { |x|
        x['blog']['css_mtime'] =
          File.mtime('out/style.css').strftime('%Y%m%dT%H%M%S') }
  end

  def self.rework_text(content)

    o = StringIO.new
    in_code = false

    content.split("\n").each do |line|

      initial_in_code = in_code

      o.write(
        if in_code
          if line == '```'
            in_code = false
            "</code></pre>"
          else
            line
              .gsub('<', '&lt;').gsub('>', '&gt;')
              .gsub('_', '&lowbar;')
              #.gsub('&', '&ampersand;')
          end
        elsif line.match(/```([a-z]+)\s*/)
          in_code = true
          "\n<pre><code class=\"#{$1}\">"
        else
          line
        end)

        o.write("\n") unless initial_in_code == false && in_code == true
    end

    o.string
  end
end

