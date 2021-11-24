
# Wed Nov 24 08:01:17 JST 2021

SHEETS = [
  [ "Noréaz",
    "Next to a small river",
    "No protection",
    "The temple",
    "Ogbert the blacksmith", ],
  [ "Champbois",
    "On a small hill",
    "Wooden fence, one gate, no towers",
    "The mill",
    "Zipper the wizard", ],
  [ "Minskytonic",
    "Next to an old mine",
    "Stone wall",
    "The blood fountain in the middle",
    "Lady Jessica", ],
  [ "Petaouschnok",
    "In the middle of a forest",
    "Concealed in a magic plane",
    "The haunted farm north",
    "Old Branagh (undead under cover)", ] ]
LENGTH =
  SHEETS.first.length

WIDTH = 80
WID = WIDTH / SHEETS.length

def split(s)
  r = [ '' ]
  s.split.each do |w|
    l = r.last
    if l.length + w.length > WID - 1
      r << w
    else
      r[-1] = l + (l.length > 0 ? ' ' : '') + w
    end
  end
  r
end

for l in 1..LENGTH

  puts
  puts "<pre>"

  sheets = SHEETS
    .collect { |s| s[0, l] }
    .transpose
    .collect { |s| s.rotate(l - 1) }

  sheets.each do |line|
    f = "| %-#{WID}s " * line.length
    ll = line.collect { |s| split(s) }
    lc = ll.collect(&:length).max
    lc.times do |li|
      puts f % ll.collect { |a| a[li] }
    end
    puts f % ([ '' ] * line.length)
  end

  f = "%-#{WID}s   " * sheets[0].length
  ps = sheets[0].length.times.collect { |i| "Player #{i}" }
  ps[0] = 'GM'
  ps = ps.collect { |pn| "^^#{pn}^^" }
  puts
  puts f % ps

  puts "</pre>"
  puts
end

