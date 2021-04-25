
require 'webrick'


renderer =
  Thread.new do

    last_mtime = nil

    loop do
      begin

        mtime = Dir['posts/*.md'].collect { |pa| File.mtime(pa).to_f }.max

        if mtime != last_mtime
          puts 'rendering...'
          load('lib/render_posts.rb')
          last_mtime = mtime
        else
          sleep 1.4
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

