
require 'blog'

vars = Blog.merge_vars({})

posts =
  Dir['posts/*.md'].sort.reverse.collect do |path|

    vars, content = Blog.load_post(path)

    pa = File.basename(path, '.md') + '.html'
    pa = File.join(vars['blog']['uri'], pa)
    pa = pa + '?t=' + vars['_title'] + '&amp;s=smap'

    print " #{path}"

    mt = File.mtime(path).to_www_s

    "<url><loc>#{pa}</loc>\n  <lastmod>#{mt}</lastmod></url>"
  end

vars = {}
vars['lastmod'] = Time.now.to_www_s
vars['CONTENT'] = posts.join("\n")

layout = File.read('layouts/sitemap.xml')
content = layout.substitute(vars)

File.open('out/sitemap.xml', 'wb') { |f| f.print(content) }

puts "\n. wrote out/sitemap.xml"

