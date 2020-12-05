
require 'webrick'


renderer =
  Thread.new do

    digest = nil

    loop do
      begin

        d1 = Dir['posts/*.md']
          .sort
          .collect { |pa| [ pa, File.mtime(pa).to_f.to_s ].join(' ') }
          .join("\n")

        if d1 != digest
          puts 'rendering...'
          load('lib/render_posts.rb')
          digest = d1
        else
          sleep 1
        end

      rescue => err
        puts "=" * 80
        p err
        puts err.backtrace
        puts ("=" * 79) + '.'
      end
    end
  end


server = WEBrick::HTTPServer.new(Port: 7000, DocumentRoot: 'out/')

trap('INT') do
  renderer.kill
  server.shutdown
end

server.start

