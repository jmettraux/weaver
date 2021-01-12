
require 'blog'


post_partial = File.read('partials/all-post.html')
tag_partial = File.read('partials/index-post-tag.html') # sic

all_tags = []

posts =
  Dir['posts/*.md'].sort.reverse.collect do |path|

    print " #{path}"

    vars, content = Blog.load_post(path)

    content = content.split("\n", 2).last # remove title
    vars['CONTENT'] = Blog.md_render(content.substitute(vars))

    vars['ctags'] = vars['tags']
      .collect { |tag| "tag-#{tag}" }
      .join(' ')
    vars['TAGS'] = vars['tags']
      .collect { |tag| tag_partial.substitute({ tag: tag }) }
      .join(' ')

    all_tags.concat(vars['tags'])

    post_partial.substitute(vars)
  end

vars = Blog.merge_vars({})

vars['CONTENT'] = posts.join("\n")

vars['all_tags'] = all_tags
  .uniq
  .sort
#vars['stags'] = vars['all_tags']
#  .join(' ')
vars['ALL_TAGS'] = vars['all_tags']
  .collect { |tag| tag_partial.substitute({ tag: tag }) }
  .join(' ')
vars['description'] =
  vars['blog']['title']
vars['twitter'] =
  { title: vars['blog']['title'],
    description: vars['blog']['subtitle'],
    image: vars['blog']['image'] }

layout = File.read('layouts/all.html')
content = layout.substitute(vars)

File.open('out/all.html', 'wb') { |f| f.print(content) }

puts "\n. wrote out/all.html"

