(function(){
  "use strict";
  var i=10;
  function increase(){
    i++;
    document.getElementById('headr').innerHTML= +i;
  }
  var btn = document.getElementById('counter-btn');
  btn.addEventListener("click",increase);
})();

(function(){
  "use strict";
  function addPara(){
    var para = document.createElement("p");
    var content = document.getElementById("headr").innerHTML
    var text = document.createTextNode(content);
    para.appendChild(text);
    document.body.appendChild(para);
  }
  var btn = document.getElementById('append-para-btn');
  btn.addEventListener("click",addPara);
})();

(function(){
  function alertFunc(){
    alert(document.getElementById("headr").innerHTML);
  }
  var btn = document.getElementById('alert-btn');
  btn.addEventListener("click",alertFunc);
})();
