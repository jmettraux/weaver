
require 'blog'


post_layout = File.read('layouts/post.html')
tag_layout = File.read('layouts/post-tag.html')

Dir['posts/*.md'].sort.each do |path|

  fn = 'out/' + File.basename(path, '.md') + '.html'

  File.open(fn, 'wb') { |f|

    vars, content = Blog.load_post(path)

    sc = content.substitute(vars)

    vars['CONTENT'] = Blog.md_render(sc)

    vars['TAGS'] = vars['tags']
      .collect { |tag| tag_layout.substitute({ tag: tag }) }
      .join(' ')

    ct = content
      .split("\n")
      .reject { |l| l == '' }
      .reject { |l| l.match(/^(#|\s*<|-->)/) }
      .take(2)
      .join("\n")
    vars['description'] = Blog
      .md_render(ct.substitute(vars), mode: 'text', index: true)
      .gsub(/ \(https?:[^)]+\)/, '')
      .gsub(/"/, '\"')
      .strip
#puts; puts 'v' * 80
#pp ct
#puts '^' * 80; puts

    timg = vars['twitter_image'] || vars['image']

    vars['twitter'] = {
      title:
        vars['title'],
      description:
        vars['description'],
      image:
        timg ? File.join(vars['blog']['uri'], timg) : vars['blog']['image'] }

    f.print(post_layout.substitute(vars))
  }

  puts ". wrote #{fn}"
end

