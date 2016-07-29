var names = {
  'de' : 'Richtig Falsh',
  'en' : 'Right Wrong',  // Approved.
  'es' : 'Bien Mal',  // Approved.
  'fr' : 'Bien Mal',
  'hy' : 'Ճիշտ Սխալ',  // Approved.
  'it' : 'Giusto Sbagliato',
  'pl' : 'Dobrze Źle',
  'pt' : 'Certo Errado',
  'ru' : 'Правильно Не Правильно',
  'sv' : 'Rätt Fel',  // Approved.
};

var userLangs = navigator.languages.concat(['en']);
console.log(userLangs);
var blogName = '';
for (var i = 0; i < userLangs.length; i++) {
  var possibleName = names[userLangs[i].substring(0,2)];
  if (possibleName != undefined) {
    blogName = possibleName;
    break;
  }
}
document.getElementById('blogname').innerHTML = blogName;
