var webPage = require('webpage');
var page = webPage.create();

var fs = require('fs');
var path = './data/processed/html/critters-fish-n.html'

page.open('https://animalcrossing.fandom.com/wiki/Fish_(New_Horizons)#Northern%20Hemisphere', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});
