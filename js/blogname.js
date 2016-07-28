var names = {
  'en' : 'Right Wrong',
  'es' : 'Bien Mal',
  'fr' : 'Bien Mal',
  'it' : 'Giusto Sbagliato',
  'pt' : 'Certo Errado',
  'ru' : 'Правильно Не Правильно',
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
