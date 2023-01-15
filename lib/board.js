
var eow = 'eow';
var s = [];
Array
  .from(document.querySelectorAll('article.entry a[target="_blank"]'))
  .slice(0, 70)
  .forEach(function(e) {
    var h = e.href;
    var a =
      h.indexOf('\/alexschroeder.ch\/') > -1 ? '#' :
      h.indexOf('?') > -1 ? '&' :
      '?';
    h = h + a + eow;
    var u = new URL(h); u.protocol = 'https:';
    s.push("\n<hr/>\n");
    s.push(`[${e.textContent}](${u.toString()})`);
  });
console.log(s.join("\n"));

//var u =
//  "data:text/plain;base64," +
//  window.btoa(s.join("\n").replace(
//    /[\u00A0-\u2666]/g,
//    function(c) { return '&#' + c.charCodeAt(0) + ';'; }));
//window.location.href = u;
//console.log(u);
//window.open(u, '_blank');
//window.open(u);

//navigator.clipboard
//  .writeText(s.join("\n"))
//  .then(
//    function() { console.log("copied."); },
//    function() { console.log("copy failed."); });

//window.open("https://maps.google.com", '_blank');

//var a = document.createElement("a");
//a.id = "the_weaver";
//a.href = u;
//a.target = "_blank";
//document.body.appendChild(a);
//a.click();

