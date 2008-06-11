var Cookies = {

  /*  name - name of the cookie
      value - value of the cookie
      [path] - path for which the cookie is valid (defaults to path of calling document)
      [expires] - expiration date of the cookie (defaults to end of current session)
      [domain] - domain for which the cookie is valid (defaults to domain of calling document)
      [secure] - Boolean value indicating if the cookie transmission requires a secure transmission
      * an argument defaults when it is assigned null as a placeholder
      * a null placeholder is not required for trailing omitted arguments */
  set : function(name, value, path, expires, domain, secure) {
    var curCookie = name + "=" + escape(value) +
        ((expires) ? "; expires=" + expires.toUTCString() : "; expires=" + new Date('January 11, 2011 00:00:00')) +
        ((path) ? "; path=" + path : "") +
        ((domain) ? "; domain=" + domain : "") +
        ((secure) ? "; secure" : "");
    document.cookie = curCookie;
  },
  

  /*  name - name of the desired cookie
      return string containing value of specified cookie or null if cookie does not exist */
  get : function(name) {
    var dc = document.cookie;
    var prefix = name + "=";
    var begin = dc.indexOf("; " + prefix);
    if (begin == -1) {
      begin = dc.indexOf(prefix);
      if (begin != 0) return null;
    } else
      begin += 2;
    var end = document.cookie.indexOf(";", begin);
    if (end == -1)
      end = dc.length;
    return unescape(dc.substring(begin + prefix.length, end));
  },
  

  /*  name - name of the cookie
      [path] - path of the cookie (must be same as path used to create cookie)
      [domain] - domain of the cookie (must be same as domain used to create cookie)
      path and domain default if assigned null or omitted if no explicit argument proceeds */
  del : function(name, path, domain) {
    if (this.get(name)) {
      document.cookie = name + "=" +
      ((path) ? "; path=" + path : "") +
      ((domain) ? "; domain=" + domain : "") +
      "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
  },
  

  /*  date - any instance of the Date object
      * hand all instances of the Date object to this function for "repairs" */
  fixDate : function(date) {
    var base = new Date(0);
    var skew = base.getTime();
    if (skew > 0)
      date.setTime(date.getTime() - skew);
  }
     
}
