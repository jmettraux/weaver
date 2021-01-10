
require 'blog'


layout = File.read('layouts/copyright.html')

vars = Blog.merge_vars({})

vars['description'] =
  vars['blog']['title']
vars['twitter'] =
  { title: vars['blog']['title'],
    description: vars['blog']['subtitle'],
    image: vars['blog']['image'] }

content = layout.substitute(vars)

File.open('out/copyright.html', 'wb') { |f| f.print(content) }

puts ". wrote out/copyright.html"

