
# Copyright (c) 2015-2020, John Mettraux, jmettraux@gmail.com
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Made in Japan.

#require 'redcarpet'
#require 'redcarpet/render_strip'

require 'blog'

vars = Blog.merge_vars({})

posts =
  Dir['posts/*.md'].sort.reverse.collect do |path|

    vars, content = Blog.load_post(path)

    pa = path.split('/', 2)[1].gsub(/\.md\A/, '.html')
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

