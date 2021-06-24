
HOST = shooto
CURRENT != ls -1 -t posts/ | head -1
CURR != basename $(CURRENT) '.md'


render: index posts copyright atom sitemap
c: render

#rp: render publish

index:
	bundle exec ruby -Ilib lib/render_index.rb
posts:
	bundle exec ruby -Ilib lib/render_posts.rb
copyright:
	bundle exec ruby -Ilib lib/render_copyright.rb
atom:
	bundle exec ruby -Ilib lib/render_atom.rb
sitemap:
	bundle exec ruby -Ilib lib/render_sitemap.rb

W:
	vim -c ":Vt posts/"

draft:
	vim draft.md
d: draft


new:
	bundle exec ruby -Ilib lib/new_post.rb
n: new
write:
	vim posts/$(CURRENT)
w: write

backup:
	@scp .todo.md draft*.md posts/$(CURRENT) out/images/$(CURR)_* $(HOST):tmp/
bak: backup
b: backup

publish:
	rsync -azv --delete --delete-excluded \
      --exclude *.swp \
      out/ $(HOST):/var/www/htdocs/weaver.skepti.ch/
p: publish

cleandrafts:
	ssh $(HOST) '/bin/sh -c "rm -fv /var/www/htdocs/weaver.skepti.ch/draft*.{html,jpg,png,gif}"'
cleand: cleandrafts

Serve: render
	ruby -run -ehttpd out/ -p7000
serve:
	bundle exec ruby -Ilib lib/serve.rb
S: Serve
s: serve

#redate:
#	bundle exec ruby -Ilib lib/redate_post.rb posts/$(CURRENT)

touch:
	touch posts/*.md

ping:
	bundle exec ruby -Ilib lib/ping.rb --dry
PING:
	bundle exec ruby -Ilib lib/ping.rb --not-dry

log:
	ssh -t $(HOST) cat /var/www/logs/weaver_access.log | ruby lib/log.rb
tail:
	ssh -t $(HOST) tail -f /var/www/logs/weaver_access.log | ruby lib/tail.rb


.PHONY: current posts backup log tail ping PING touch

