function addLoadEvent(func) {
  var oldonload = window.onload;
  if (typeof window.onload != 'function') {
    window.onload = func;
  } else {
    window.onload = function() {
      oldonload();
      func();
    }
  }
};

function clickclear(thisfield, defaulttext) {
  if (thisfield.value == defaulttext) {
    thisfield.value = "";
  }
};

function tableruler()
{
 if (document.getElementById && document.createTextNode)
  {
   var tables=document.getElementsByTagName('table');
   for (var i=0;i<tables.length;i++)
   {
    if(tables[i].className=='ruler')
    {
     var trs=tables[i].getElementsByTagName('tr');
     for(var j=0;j<trs.length;j++)
     {
      if(trs[j].parentNode.nodeName=='TBODY' && trs[j].parentNode.nodeName!='TFOOT')
       {
       trs[j].onmouseover=function(){this.className='ruled';return false}
       trs[j].onmouseout=function(){this.className='';return false}
     }
    }
   }
  }
 }
};

function onlynumbers(evt) {
	evt = (evt) ? evt : window.event;
	var charCode = (evt.charCode) ? evt.charCode : ((evt.which) ? evt.which : evt.keyCode);
	if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 46 && charCode != 44 && charCode != 63234 && charCode != 63235 && charCode != 45) {
		return false;
	}
	return true;
};

function submitenter(fld, evt) {
	evt = (evt) ? evt : window.event;
	var charCode = (evt.charCode) ? evt.charCode : ((evt.which) ? evt.which : evt.keyCode);
  
  if (charCode == 13) {
     fld.form.submit();
     return false;
  }
  else
     return true;
};
