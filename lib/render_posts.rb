
require 'blog'


post_layout = File.read('layouts/post.html')
tag_partial = File.read('partials/post-tag.html')
meta_tag_partial = File.read('partials/post-meta-tag.html')

paths = Dir['posts/*.md'].sort

do_render_post =
  lambda do |path, i|

    dt = File.basename(path, '.md')
    fn = "out/#{dt}.html"

    next if (
      File.exist?(fn) &&
      (File.mtime(fn) > File.mtime(path)) &&
      (i < paths.length - 2))

    draft = fn.match?(/^out\/draft/)

    prv = paths[i - 1]
    nxt = paths[i + 1]
      #
    if draft
      prv = nil
      nxt = nil
    end
      #
    f = lambda { |kla, path|
        #
      d = File.basename(path.split('/').last, '.md')
      d1 = [ d[0, 4], d[4, 2], d[6, 2] ].join('-')
      t = File.read(path).match(/^## (.+)\n/)[1]
      t1 = t.to_safe_string
      #l = "#{d}.html?t=#{t1}&l=#{kla}"
      l = "#{d}.html?t=#{t1}"
        #
      "<div class=\"#{kla}\">" +
      "<a href=\"#{l}\">" +
      "#{kla == 'prev' ? '← ' : ''}#{d1} #{t}#{kla == 'next' ? ' →' : ''}</a>" +
      "</div>" }
        #
    prv = f['prev', prv] if prv
    nxt = f['next', nxt] if nxt

    File.open(fn, 'wb') { |f|

      vars, content = Blog.load_post(path)

      vars['PREV'] = prv
      vars['NEXT'] = nxt
        # nil if draft!!!

      sc = content.substitute(vars)

      vars['CONTENT'] = Blog.md_render(sc, footnote_prefix: dt)

      vars['TAGS'] = vars['tags']
        .collect { |tag| tag_partial.substitute({ tag: tag }) }
        .join(' ')
      vars['meta_tags'] = vars['tags']
        .collect { |tag| meta_tag_partial.substitute({ tag: tag }) }
        .join.strip

      ct = content
        .split("\n")
        .reject { |l| l == '' }
        .reject { |l| l.match(/^(#|\s*<|-->)/) }
        .take(2)
        .join("\n")
      vars['description'] = Blog
        .md_render(ct.substitute(vars), mode: 'text', index: true)
        .gsub(/ \([^)]+\)/, '')
        .gsub(/"/, "'")
        .strip
        #.gsub(/ \(https?:[^)]+\)/, '')
  #puts; puts 'v' * 80
  #puts vars['description']
  #puts '^' * 80; puts

      timg = vars['twitter_image'] || vars['image']

      vars['og'] =
        { title:
            vars['title'],
          type:
            'article',
          image:
            timg ? File.join(vars['blog']['uri'], timg) : vars['blog']['image'],
          url:
            vars['uri'] + '&s=og' }

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

paths.each_with_index(&do_render_post)

Dir['draft*.md'].sort.each_with_index(&do_render_post)

