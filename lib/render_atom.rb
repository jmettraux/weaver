
require 'redcarpet'
require 'redcarpet/render_strip'

require 'blog'


partial = File.read('partials/atom-post.xml')

posts =
  Dir['posts/*.md'].sort.reverse.take(28).collect do |path|

    print " #{path}"

    vars, content = Blog.load_post(path)

    next if vars['tags'].include?('draft')

    content = content.split("\n", 2).last # remove title

    ct = content
      .split("\n")
      .reject { |l| l == '' }
      .reject { |l| l.match(/^(#|\s*<|-->)/) }
      .take(2)
      .join("\n")
    vars['summary'] = Blog
      .md_render(ct.substitute(vars), mode: 'text', index: true)
      .gsub(/ \([^)]+\)/, '')
      .gsub(/&(?!amp;)/, '&amp;')
      .gsub(/"/, '\"')
      .strip
#puts; puts 'v' * 80
#pp ct
#puts '^' * 80; puts

    vars['CONTENT'] =
      Blog.html_to_atom_xhtml(
        Blog.md_render(content.substitute(vars)))

    # http://edward.oconnor.cx/2007/02/representing-tags-in-atom

    vars['TAGS'] =
      vars['tags'].collect { |t|
        %{
<category scheme="https://weaver.skepti.ch/tags/" term="#{t}" />
        }.strip
      }.join("\n")

    partial.substitute(vars).strip
  end

vars = Blog.merge_vars({})
vars['CONTENT'] = posts.join("\n")

layout = File.read('layouts/atom.xml')
content = layout.substitute(vars)

File.open('out/atom.xml', 'wb') { |f| f.print(content) }

puts "\n. wrote out/atom.xml"

