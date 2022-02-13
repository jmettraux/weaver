
HOST = shooto
CURRENT != ls -1 -t posts/ | head -1
CURR != basename $(CURRENT) '.md'
BXR = bundle exec ruby -Ilib


render: index posts copyright atom sitemap
c: render

#rp: render publish

index:
	$(BXR) lib/render_index.rb
posts:
	$(BXR) lib/render_posts.rb
copyright:
	$(BXR) lib/render_copyright.rb
atom:
	$(BXR) lib/render_atom.rb
sitemap:
	$(BXR) lib/render_sitemap.rb

W:
	vim -c ":Vt posts/"

draft:
	vim draft.md
d: draft


new:
	$(BXR) lib/new_post.rb
n: new
write:
	vim posts/$(CURRENT)
w: write

backup:
	#@time scp .todo.md draft*.md out/images/draft_* posts/$(CURRENT) out/images/$(CURR)_* $(HOST):tmp/
	@time scp .todo.md posts/$(CURRENT) out/images/$(CURR)_* $(HOST):tmp/
bak: backup
b: backup

publish:
	chmod a+r out/docs/*.pdf
	chmod a+r out/images/*.jpg
	chmod a+r out/images/*.png
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
	$(BXR) lib/serve.rb
S: Serve
s: serve

touch:
	touch posts/*.md

ping:
	$(BXR) lib/ping.rb --dry
PING:
	$(BXR) lib/ping.rb --not-dry

log:
	ssh -t $(HOST) cat /var/www/logs/weaver_access.log | ruby lib/log.rb
tail:
	ssh -t $(HOST) tail -f /var/www/logs/weaver_access.log | ruby lib/tail.rb


.PHONY: current posts backup log tail ping PING touch

