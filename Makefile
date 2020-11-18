
render: index all posts copyright atom sitemap
c: render

#rp: render publish

index:
	bundle exec ruby -Ilib lib/render_index.rb
all:
	bundle exec ruby -Ilib lib/render_all.rb
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

serve:
	ruby -run -ehttpd out/ -p7000
s: serve
browse:
	open http://127.0.0.1:7000
b: browse

redate:
	bundle exec ruby -Ilib lib/redate_post.rb posts/`ls -1 -t posts/ | head -1`

backup:
	cd .. && tar cjvf ~/Dropbox/backup/blog_`date +%Y%m%d_%H%M%S`.tbz blog/

log:
	ssh -t shooto cat /var/www/logs/access.log | grep "^weaver" > weaver.log
	ruby lib/log.rb < weaver.log > w.log
	rm weaver.log
	tail -1 w.log
	wc -l w.log
	mv w.log tmp/weaver_`tail -1 w.log | ruby -e "print STDIN.read.match(/\[(.+)\]/)[1].gsub(/[-:]/, '').gsub(/[^0-9]/, '_')"`.log


.PHONY: backup posts publish redate serve log


# TODO: leverage make, don't rewrite each time

