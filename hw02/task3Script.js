(function(){
  function lorem(){
    "use strict";
    document.getElementsByClassName('lorem-ipsum')[0].style.display='block';
    document.getElementsByClassName('bottles')[0].style.display='none';
    document.getElementsByClassName('last-thing')[0].style.display='none';
  }
  var btn = document.getElementById('link-1');
  btn.addEventListener("click",lorem);
})();

(function(){
  function bottles(){
    document.getElementsByClassName('bottles')[0].style.display='block';
    document.getElementsByClassName('lorem-ipsum')[0].style.display='none';
    document.getElementsByClassName('last-thing')[0].style.display='none';
  }
  var btn = document.getElementById('link-2');
  btn.addEventListener("click",bottles);
})();

(function(){
  function last(){
    document.getElementsByClassName('last-thing')[0].style.display='block';
    document.getElementsByClassName('lorem-ipsum')[0].style.display='none';
    document.getElementsByClassName('bottles')[0].style.display='none';
  }
  var btn = document.getElementById('link-3');
  btn.addEventListener("click",last);
})();
