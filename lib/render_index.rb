
require 'blog'


post_layout = File.read('layouts/index-post.html')
tag_layout = File.read('layouts/index-post-tag.html')

all_tags = []

posts =
  Dir['posts/*.md'].sort.reverse.collect do |path|

    print " #{path}"

    vars, content = Blog.load_post(path)

    content = content
      .split("\n", 2).last # remove title
      .split("\n")
      .reject { |l| l.match(/^(#|<|-->)/) }
    content = content[1, 2].join("\n") + "\n&hellip;"
    vars['CONTENT'] = Blog.md_render(content.substitute(vars), index: true)

    vars['ctags'] = vars['tags']
      .collect { |tag| "tag-#{tag}" }
      .join(' ')
    vars['TAGS'] = vars['tags']
      .collect { |tag| tag_layout.substitute({ tag: tag }) }
      .join(' ')

    all_tags.concat(vars['tags'])

    post_layout.substitute(vars)
  end

vars = Blog.merge_vars({})

vars['CONTENT'] = posts.join("\n")

vars['all_tags'] = all_tags
  .uniq
  .sort
vars['ALL_TAGS'] = vars['all_tags']
  .collect { |tag| tag_layout.substitute({ tag: tag }) }
  .join(' ')
vars['description'] =
  vars['blog']['title']
vars['twitter'] =
  { title: vars['blog']['title'],
    description: vars['blog']['subtitle'],
    image: vars['blog']['image'] }

layout = File.read('layouts/index.html')
content = layout.substitute(vars)

File.open('out/index.html', 'wb') { |f| f.print(content) }

puts "\n. wrote out/index.html"

