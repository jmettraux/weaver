
require 'blog'


post_partial = File.read('partials/index-post.html')
tag_partial = File.read('partials/index-post-tag.html')

all_tags = []
months = {}

posts =
  Dir['posts/*.md'].sort.reverse.collect do |path|

    print " #{path}"

    vars, content = Blog.load_post(path)

    content = content
      .gsub(/\n<figcaption>.+?<\/figcaption>/m, '')
      .split("\n", 2).last # remove title
      .split("\n")
      .reject { |l| l.match(/^ *(#|<|-->)/) }
    content =
      content[1, 2].join("\n") + "\n&hellip;"
    vars['CONTENT'] =
      Blog.md_render(content.substitute(vars), index: true)
        .gsub(/^\s*Tl;dr\s+/, '')

    vars['ctags'] = vars['tags']
      .collect { |tag| "tag-#{tag}" }
      .join(' ')
    vars['TAGS'] = vars['tags']
      .collect { |tag| tag_partial.substitute({ tag: tag }) }
      .join(' ')

    vars['IMAGE0'] =
      vars['blog']['rimage']
    vars['IMAGE'] =
      vars['twitter_image'] || vars['image'] || vars['blog']['rimage']

    all_tags.concat(vars['tags'])

    d = vars['date'][0, 10]
    m = d[0, 7]
    months[m] ||= [ m, '#' + d.gsub(/-/, ''), 0 ]
    months[m][-1] = months[m][-1] + 1

    post_partial.substitute(vars)
  end


vars = Blog.merge_vars({})

vars['CONTENT'] =
  posts.join("\n")
vars['MONTHS'] =
  ''
  #months.map { |_, m| "<li><a href='#{m[1]}'>#{m[0]}</a></li>" }.join("\n")

vars['all_tags'] = all_tags
  .uniq
  .sort
vars['ALL_TAGS'] = vars['all_tags']
  .collect { |tag| tag_partial.substitute({ tag: tag }) }
  .join(' ')
vars['description'] =
  vars['blog']['title']
vars['uri'] =
  vars['blog']['uri']
vars['og'] =
  { title: vars['blog']['title'],
    type: 'website',
    image: vars['blog']['image'],
    url: vars['blog']['uri'] }
vars['twitter'] =
  { title: vars['blog']['title'],
    description: vars['blog']['subtitle'],
    image: vars['blog']['image'] }

layout = File.read('layouts/index.html')
content = layout.substitute(vars)

File.open('out/index.html', 'wb') { |f| f.print(content) }

puts "\n. wrote out/index.html"

