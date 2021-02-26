
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

new:
	bundle exec ruby -Ilib lib/new_post.rb
n: new
write:
	$(EDITOR) posts/`ls -1 -t posts/ | head -1`
w: write

publish:
	rsync -azv --delete --delete-excluded \
      --exclude *.swp \
      out/ shooto:/var/www/htdocs/weaver.skepti.ch/
p: publish

Serve: render
	ruby -run -ehttpd out/ -p7000
serve:
	bundle exec ruby -Ilib lib/serve.rb
S: Serve
s: serve

redate:
	bundle exec ruby -Ilib lib/redate_post.rb posts/`ls -1 -t posts/ | head -1`

#backup:
#	cd .. && tar cjvf ~/Dropbox/backup/blog_`date +%Y%m%d_%H%M%S`.tbz blog/

ping:
	bundle exec ruby -Ilib lib/ping.rb --dry
PING:
	bundle exec ruby -Ilib lib/ping.rb --not-dry

log:
	ssh -t shooto cat /var/www/logs/weaver_access.log | ruby lib/log.rb
tail:
	ssh -t shooto tail -f /var/www/logs/weaver_access.log | ruby lib/tail.rb


.PHONY: posts

