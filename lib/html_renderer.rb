
class HtmlRenderer < Redcarpet::Render::HTML

  attr_accessor :footnote_prefix

  def initialize(opts)

    super

    @footnotes = []
  end

  # footnotes:
  #   https://www.markdownguide.org/extended-syntax/

  def footnotes(content)

    nil
  end

  def footnote_ref(number)

    "<a class=\"footnote\" " +
    "id=\"a-#{fnote_prefix}-#{number}\" " +
    "href=\"##{fnote_prefix}-#{number}\" " +
    ">#{number}</a>"
  end

  def footnote_def(content, number)

    @footnotes << [ "#{fnote_prefix}-#{number}", number, content.strip ]

    nil
  end

  def preprocess(full_doc)

    @footnotes.clear

    full_doc
  end

  def postprocess(full_doc)

    full_doc + "\n" + render_footnotes
  end

  protected

  def render_footnotes

    s = StringIO.new
    s << "<ol class=\"footnotes\">\n"

    @footnotes.each do |id, number, content|
      s << "<li id=\"#{fnote_prefix}-#{number}\">"
      s << "<a class=\"number\" href=\"#a-#{fnote_prefix}-#{number}\">"
      s << number.to_s << '</a>'
      s << content
      s << "\n</li><!-- end of footnote ##{fnote_prefix}-#{number} -->"
    end

    s << "\n</ol><!-- end of footnotes -->\n"

    s.string
  end

  def fnote_prefix

    @footnote_prefix || '19700101'
  end
end

