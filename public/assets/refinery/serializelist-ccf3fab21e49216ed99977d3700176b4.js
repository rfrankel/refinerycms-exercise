/**
 * jQuery Serialize List
 * Copyright (c) 2009 Mike Botsko, Botsko.net LLC
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * Copyright notice and license must remain intact for legal use
 * Version .2
 *
 * Serialize an unordered or ordered list item. Optional ability
 * to determine which attributes are included. The serialization
 * will be read by PHP as a multidimensional array which you may
 * use for saving state.
 *
 * http://github.com/botskonet/jquery.serialize-list
 */
(function(e){e.fn.serializelist=function(t){var n={attributes:["id"],allow_nest:!0,prepend:"ul",att_regex:!1,is_child:!1},r=e.extend(n,t),i=r.attributes,s="",o,u,a,f,l=function(e,t){if(!r.att_regex)return t;for(u in r.att_regex)if(r.att_regex[u].att===e)return t.replace(r.att_regex[u].regex,"")};return r.is_child||(r.prepend="&"+r.prepend),this.each(function(t,n){e(n).children().each(function(n,u){if(r.allow_nest||i.length>1)for(a in i)o=l(i[a],e(u).attr(i[a])),s+=r.prepend+"["+t+"]["+n+"]["+i[a]+"]="+o;else o=l(i[0],e(u).attr(i[0])),s+=r.prepend+"["+t+"]["+n+"]="+o;r.allow_nest&&(f=r.prepend+"["+t+"]["+n+"][children]",e(u).children().each(function(){if(this.tagName=="UL"||this.tagName=="OL")s+=e(this).serializelist({prepend:f,is_child:!0})})),n++})}),s}})(jQuery);