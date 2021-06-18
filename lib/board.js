
var s = [];
Array
  .from(document.querySelectorAll("a.entry__title"))
  .slice(0, 28)
  .forEach(function(e) {
    //console.log(e)
    s.push("\n<hr/>\n");
    s.push("[" + e.textContent + "](" + e.href + ")");
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

