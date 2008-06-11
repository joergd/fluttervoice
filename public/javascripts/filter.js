var Filter = {

  submit : function(base_url) {
    location.href = base_url + this.invoice_states();
  },
  
  init : function() {
    var hide_filter = eval(Cookies.get('hide_filter'));
    if (!hide_filter) {
      this.show();
    }
  },
  
  show : function() {
    Element.hide('show_filter');
    Element.show('hide_filter');
    Effect.Appear('filter');
    Cookies.set('hide_filter', 'false', '/');
  },
  
  hide : function() {
    Element.hide('hide_filter');
    Element.show('show_filter');
    Effect.Fade('filter');
    Cookies.set('hide_filter', 'true', '/');
  },
  
  uncheck_boxes : function(all) {
    var all = (all == null) ? false : all;
    $A(document.getElementsByName("filterbox")).each(function(box) {
      if (all && box.value != "all") {
        box.checked = false;
      } else if (!all && box.value == "all") {
        box.checked = false;
      }
    });
  },
  
  invoice_states : function() {
    var states = new Array(); 
    $A(document.getElementsByName("filterbox")).each(function(box) {
      if (box.checked) {
        states.push(box.value);
      }
    });
    return states.length == 0 ? "all" : states.join(','); 
  }
}
