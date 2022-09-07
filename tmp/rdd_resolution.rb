
minus_height_column = (1..21).to_a
multipliers = [ 0.25 ] + (0.5 .. 8.5).step(0.5).to_a

#p minus_height_column
#p multipliers

puts %{
<html>
<head>
<title>RdD Resolution Table</title>
</head>
<body>

<style>
table.rdd-resolution {
  font-family: monospace;
  font-size: 8pt;
  border-collapse: collapse;
}
table.rdd-resolution th {
  position: sticky;
  top: 0;
  font-size: 12pt;
  background-color: white;
}
table.rdd-resolution td {
  border-left: 1px solid black;
  border-right: 1px solid black;
}
/*
table.rdd-resolution td.ref {
  border-left: 1px solid #eeeeee;
  border-right: 1px solid #eeeeee;
}
*/
table.rdd-resolution th, table.rdd-resolution td {
  /*width: 2em;*/
  text-align: center;
  padding: 0 0.1em;
}
table.rdd-resolution td .success {
  font-size: 14pt;
}

table.rdd-resolution td .con { display: grid; }
table.rdd-resolution td .con div { align-self: center; }
table.rdd-resolution td .con .tfailure { grid-area: 1 / 1 / 1 / 1; }
table.rdd-resolution td .con .pfailure { grid-area: 2 / 1 / 2 / 1; }
table.rdd-resolution td .con .success { grid-area: 1 / 2 / 3 / 2; }
table.rdd-resolution td .con .ssuccess { grid-area: 1 / 3 / 1 / 3; }
table.rdd-resolution td .con .psuccess { grid-area: 2 / 3 / 2 / 3; }
table.rdd-resolution td .con .success { padding: 0 0.1em; }
table.rdd-resolution tr:nth-child(odd) { background-color: #e0e0e0; }
table.rdd-resolution td.ref { background-color: white; }
</style>
<table class="rdd-resolution">
}

print "<tr>"
(-10..7).to_a.each do |mod|
  print "<th class=#{mod == -8 ? 'ref' : ''}>"
  print mod > -1 ? "+#{mod}" : mod.to_s
  print "</th>"
end
puts "</tr>"

minus_height_column.each do |v|
  print "<tr>"
  multipliers.each do |m|
    print "<td class=#{m == 1.0 ? 'ref' : ''}>"
    psuc = (v * m * 0.2).ceil
    ssuc = (v * m * 0.5).ceil
    suc = (v * m).floor
    tfai = 92 + ((suc - 1) * 0.1).floor; tfai = 100 if 90 < suc && suc < 101
    pfai = 80 + (suc * 0.2).ceil
    tfai =
      tfai > 100 ? '&nbsp;' :
      tfai == 100 ? '00' :
      tfai
    pfai =
      pfai > 100 ? '&nbsp;' :
      pfai == 100 ? '00' :
      pfai
    suc = suc > 0 ? suc : 1
    title =
      "1d100 →  " +
      (tfai.is_a?(Integer) ? "total failure ≥ #{tfai} | " : '') +
      (pfai.is_a?(Integer) ? "particular failure ≥ #{pfai} | " : '') +
      "SUCCESS ≤ #{suc} | " +
      "significant success ≤ #{ssuc} | " +
      "particular success ≤ #{psuc}"
    print "<div class=\"con\" title=\"#{title}\">"
    print "<div class=\"tfailure\">#{tfai}</div>"
    print "<div class=\"pfailure\">#{pfai}</div>"
    print "<div class=\"success\">#{suc}</div>"
    print "<div class=\"ssuccess\">#{ssuc}</div>"
    print "<div class=\"psuccess\">#{psuc}</div>"
    print "</div>"
    print "</td>"
  end
  puts "</tr>"
end

puts %{
</table>

</body>
</html>
}

