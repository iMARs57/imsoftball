/*! Hammer.JS - v1.0.5 - 2013-04-07
 * http://eightmedia.github.com/hammer.js
 *
 * Copyright (c) 2013 Jorik Tangelder <j.tangelder@gmail.com>;
 * Licensed under the MIT license */


(function(t,e){"use strict";function n(){if(!i.READY){i.event.determineEventTypes();for(var t in i.gestures)i.gestures.hasOwnProperty(t)&&i.detection.register(i.gestures[t]);i.event.onTouch(i.DOCUMENT,i.EVENT_MOVE,i.detection.detect),i.event.onTouch(i.DOCUMENT,i.EVENT_END,i.detection.detect),i.READY=!0}}var i=function(t,e){return new i.Instance(t,e||{})};i.defaults={stop_browser_behavior:{userSelect:"none",touchAction:"none",touchCallout:"none",contentZooming:"none",userDrag:"none",tapHighlightColor:"rgba(0,0,0,0)"}},i.HAS_POINTEREVENTS=navigator.pointerEnabled||navigator.msPointerEnabled,i.HAS_TOUCHEVENTS="ontouchstart"in t,i.MOBILE_REGEX=/mobile|tablet|ip(ad|hone|od)|android/i,i.NO_MOUSEEVENTS=i.HAS_TOUCHEVENTS&&navigator.userAgent.match(i.MOBILE_REGEX),i.EVENT_TYPES={},i.DIRECTION_DOWN="down",i.DIRECTION_LEFT="left",i.DIRECTION_UP="up",i.DIRECTION_RIGHT="right",i.POINTER_MOUSE="mouse",i.POINTER_TOUCH="touch",i.POINTER_PEN="pen",i.EVENT_START="start",i.EVENT_MOVE="move",i.EVENT_END="end",i.DOCUMENT=document,i.plugins={},i.READY=!1,i.Instance=function(t,e){var r=this;return n(),this.element=t,this.enabled=!0,this.options=i.utils.extend(i.utils.extend({},i.defaults),e||{}),this.options.stop_browser_behavior&&i.utils.stopDefaultBrowserBehavior(this.element,this.options.stop_browser_behavior),i.event.onTouch(t,i.EVENT_START,function(t){r.enabled&&i.detection.startDetect(r,t)}),this},i.Instance.prototype={on:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.addEventListener(n[i],e,!1);return this},off:function(t,e){for(var n=t.split(" "),i=0;n.length>i;i++)this.element.removeEventListener(n[i],e,!1);return this},trigger:function(t,e){var n=i.DOCUMENT.createEvent("Event");n.initEvent(t,!0,!0),n.gesture=e;var r=this.element;return i.utils.hasParent(e.target,r)&&(r=e.target),r.dispatchEvent(n),this},enable:function(t){return this.enabled=t,this}};var r=null,o=!1,s=!1;i.event={bindDom:function(t,e,n){for(var i=e.split(" "),r=0;i.length>r;r++)t.addEventListener(i[r],n,!1)},onTouch:function(t,e,n){var a=this;this.bindDom(t,i.EVENT_TYPES[e],function(c){var u=c.type.toLowerCase();if(!u.match(/mouse/)||!s){(u.match(/touch/)||u.match(/pointerdown/)||u.match(/mouse/)&&1===c.which)&&(o=!0),u.match(/touch|pointer/)&&(s=!0);var h=0;o&&(i.HAS_POINTEREVENTS&&e!=i.EVENT_END?h=i.PointerEvent.updatePointer(e,c):u.match(/touch/)?h=c.touches.length:s||(h=u.match(/up/)?0:1),h>0&&e==i.EVENT_END?e=i.EVENT_MOVE:h||(e=i.EVENT_END),h||null===r?r=c:c=r,n.call(i.detection,a.collectEventData(t,e,c)),i.HAS_POINTEREVENTS&&e==i.EVENT_END&&(h=i.PointerEvent.updatePointer(e,c))),h||(r=null,o=!1,s=!1,i.PointerEvent.reset())}})},determineEventTypes:function(){var t;t=i.HAS_POINTEREVENTS?i.PointerEvent.getEvents():i.NO_MOUSEEVENTS?["touchstart","touchmove","touchend touchcancel"]:["touchstart mousedown","touchmove mousemove","touchend touchcancel mouseup"],i.EVENT_TYPES[i.EVENT_START]=t[0],i.EVENT_TYPES[i.EVENT_MOVE]=t[1],i.EVENT_TYPES[i.EVENT_END]=t[2]},getTouchList:function(t){return i.HAS_POINTEREVENTS?i.PointerEvent.getTouchList():t.touches?t.touches:[{identifier:1,pageX:t.pageX,pageY:t.pageY,target:t.target}]},collectEventData:function(t,e,n){var r=this.getTouchList(n,e),o=i.POINTER_TOUCH;return(n.type.match(/mouse/)||i.PointerEvent.matchType(i.POINTER_MOUSE,n))&&(o=i.POINTER_MOUSE),{center:i.utils.getCenter(r),timeStamp:(new Date).getTime(),target:n.target,touches:r,eventType:e,pointerType:o,srcEvent:n,preventDefault:function(){this.srcEvent.preventManipulation&&this.srcEvent.preventManipulation(),this.srcEvent.preventDefault&&this.srcEvent.preventDefault()},stopPropagation:function(){this.srcEvent.stopPropagation()},stopDetect:function(){return i.detection.stopDetect()}}}},i.PointerEvent={pointers:{},getTouchList:function(){var t=this,e=[];return Object.keys(t.pointers).sort().forEach(function(n){e.push(t.pointers[n])}),e},updatePointer:function(t,e){return t==i.EVENT_END?this.pointers={}:(e.identifier=e.pointerId,this.pointers[e.pointerId]=e),Object.keys(this.pointers).length},matchType:function(t,e){if(!e.pointerType)return!1;var n={};return n[i.POINTER_MOUSE]=e.pointerType==e.MSPOINTER_TYPE_MOUSE||e.pointerType==i.POINTER_MOUSE,n[i.POINTER_TOUCH]=e.pointerType==e.MSPOINTER_TYPE_TOUCH||e.pointerType==i.POINTER_TOUCH,n[i.POINTER_PEN]=e.pointerType==e.MSPOINTER_TYPE_PEN||e.pointerType==i.POINTER_PEN,n[t]},getEvents:function(){return["pointerdown MSPointerDown","pointermove MSPointerMove","pointerup pointercancel MSPointerUp MSPointerCancel"]},reset:function(){this.pointers={}}},i.utils={extend:function(t,n,i){for(var r in n)t[r]!==e&&i||(t[r]=n[r]);return t},hasParent:function(t,e){for(;t;){if(t==e)return!0;t=t.parentNode}return!1},getCenter:function(t){for(var e=[],n=[],i=0,r=t.length;r>i;i++)e.push(t[i].pageX),n.push(t[i].pageY);return{pageX:(Math.min.apply(Math,e)+Math.max.apply(Math,e))/2,pageY:(Math.min.apply(Math,n)+Math.max.apply(Math,n))/2}},getVelocity:function(t,e,n){return{x:Math.abs(e/t)||0,y:Math.abs(n/t)||0}},getAngle:function(t,e){var n=e.pageY-t.pageY,i=e.pageX-t.pageX;return 180*Math.atan2(n,i)/Math.PI},getDirection:function(t,e){var n=Math.abs(t.pageX-e.pageX),r=Math.abs(t.pageY-e.pageY);return n>=r?t.pageX-e.pageX>0?i.DIRECTION_LEFT:i.DIRECTION_RIGHT:t.pageY-e.pageY>0?i.DIRECTION_UP:i.DIRECTION_DOWN},getDistance:function(t,e){var n=e.pageX-t.pageX,i=e.pageY-t.pageY;return Math.sqrt(n*n+i*i)},getScale:function(t,e){return t.length>=2&&e.length>=2?this.getDistance(e[0],e[1])/this.getDistance(t[0],t[1]):1},getRotation:function(t,e){return t.length>=2&&e.length>=2?this.getAngle(e[1],e[0])-this.getAngle(t[1],t[0]):0},isVertical:function(t){return t==i.DIRECTION_UP||t==i.DIRECTION_DOWN},stopDefaultBrowserBehavior:function(t,e){var n,i=["webkit","khtml","moz","ms","o",""];if(e&&t.style){for(var r=0;i.length>r;r++)for(var o in e)e.hasOwnProperty(o)&&(n=o,i[r]&&(n=i[r]+n.substring(0,1).toUpperCase()+n.substring(1)),t.style[n]=e[o]);"none"==e.userSelect&&(t.onselectstart=function(){return!1})}}},i.detection={gestures:[],current:null,previous:null,stopped:!1,startDetect:function(t,e){this.current||(this.stopped=!1,this.current={inst:t,startEvent:i.utils.extend({},e),lastEvent:!1,name:""},this.detect(e))},detect:function(t){if(this.current&&!this.stopped){t=this.extendEventData(t);for(var e=this.current.inst.options,n=0,r=this.gestures.length;r>n;n++){var o=this.gestures[n];if(!this.stopped&&e[o.name]!==!1&&o.handler.call(o,t,this.current.inst)===!1){this.stopDetect();break}}return this.current&&(this.current.lastEvent=t),t.eventType==i.EVENT_END&&!t.touches.length-1&&this.stopDetect(),t}},stopDetect:function(){this.previous=i.utils.extend({},this.current),this.current=null,this.stopped=!0},extendEventData:function(t){var e=this.current.startEvent;if(e&&(t.touches.length!=e.touches.length||t.touches===e.touches)){e.touches=[];for(var n=0,r=t.touches.length;r>n;n++)e.touches.push(i.utils.extend({},t.touches[n]))}var o=t.timeStamp-e.timeStamp,s=t.center.pageX-e.center.pageX,a=t.center.pageY-e.center.pageY,c=i.utils.getVelocity(o,s,a);return i.utils.extend(t,{deltaTime:o,deltaX:s,deltaY:a,velocityX:c.x,velocityY:c.y,distance:i.utils.getDistance(e.center,t.center),angle:i.utils.getAngle(e.center,t.center),direction:i.utils.getDirection(e.center,t.center),scale:i.utils.getScale(e.touches,t.touches),rotation:i.utils.getRotation(e.touches,t.touches),startEvent:e}),t},register:function(t){var n=t.defaults||{};return n[t.name]===e&&(n[t.name]=!0),i.utils.extend(i.defaults,n,!0),t.index=t.index||1e3,this.gestures.push(t),this.gestures.sort(function(t,e){return t.index<e.index?-1:t.index>e.index?1:0}),this.gestures}},i.gestures=i.gestures||{},i.gestures.Hold={name:"hold",index:10,defaults:{hold_timeout:500,hold_threshold:1},timer:null,handler:function(t,e){switch(t.eventType){case i.EVENT_START:clearTimeout(this.timer),i.detection.current.name=this.name,this.timer=setTimeout(function(){"hold"==i.detection.current.name&&e.trigger("hold",t)},e.options.hold_timeout);break;case i.EVENT_MOVE:t.distance>e.options.hold_threshold&&clearTimeout(this.timer);break;case i.EVENT_END:clearTimeout(this.timer)}}},i.gestures.Tap={name:"tap",index:100,defaults:{tap_max_touchtime:250,tap_max_distance:10,tap_always:!0,doubletap_distance:20,doubletap_interval:300},handler:function(t,e){if(t.eventType==i.EVENT_END){var n=i.detection.previous,r=!1;if(t.deltaTime>e.options.tap_max_touchtime||t.distance>e.options.tap_max_distance)return;n&&"tap"==n.name&&t.timeStamp-n.lastEvent.timeStamp<e.options.doubletap_interval&&t.distance<e.options.doubletap_distance&&(e.trigger("doubletap",t),r=!0),(!r||e.options.tap_always)&&(i.detection.current.name="tap",e.trigger(i.detection.current.name,t))}}},i.gestures.Swipe={name:"swipe",index:40,defaults:{swipe_max_touches:1,swipe_velocity:.7},handler:function(t,e){if(t.eventType==i.EVENT_END){if(e.options.swipe_max_touches>0&&t.touches.length>e.options.swipe_max_touches)return;(t.velocityX>e.options.swipe_velocity||t.velocityY>e.options.swipe_velocity)&&(e.trigger(this.name,t),e.trigger(this.name+t.direction,t))}}},i.gestures.Drag={name:"drag",index:50,defaults:{drag_min_distance:10,drag_max_touches:1,drag_block_horizontal:!1,drag_block_vertical:!1,drag_lock_to_axis:!1,drag_lock_min_distance:25},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(n.options.drag_max_touches>0&&t.touches.length>n.options.drag_max_touches))switch(t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:if(t.distance<n.options.drag_min_distance&&i.detection.current.name!=this.name)return;i.detection.current.name=this.name,(i.detection.current.lastEvent.drag_locked_to_axis||n.options.drag_lock_to_axis&&n.options.drag_lock_min_distance<=t.distance)&&(t.drag_locked_to_axis=!0);var r=i.detection.current.lastEvent.direction;t.drag_locked_to_axis&&r!==t.direction&&(t.direction=i.utils.isVertical(r)?0>t.deltaY?i.DIRECTION_UP:i.DIRECTION_DOWN:0>t.deltaX?i.DIRECTION_LEFT:i.DIRECTION_RIGHT),this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),n.trigger(this.name+t.direction,t),(n.options.drag_block_vertical&&i.utils.isVertical(t.direction)||n.options.drag_block_horizontal&&!i.utils.isVertical(t.direction))&&t.preventDefault();break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Transform={name:"transform",index:45,defaults:{transform_min_scale:.01,transform_min_rotation:1,transform_always_block:!1},triggered:!1,handler:function(t,n){if(i.detection.current.name!=this.name&&this.triggered)return n.trigger(this.name+"end",t),this.triggered=!1,e;if(!(2>t.touches.length))switch(n.options.transform_always_block&&t.preventDefault(),t.eventType){case i.EVENT_START:this.triggered=!1;break;case i.EVENT_MOVE:var r=Math.abs(1-t.scale),o=Math.abs(t.rotation);if(n.options.transform_min_scale>r&&n.options.transform_min_rotation>o)return;i.detection.current.name=this.name,this.triggered||(n.trigger(this.name+"start",t),this.triggered=!0),n.trigger(this.name,t),o>n.options.transform_min_rotation&&n.trigger("rotate",t),r>n.options.transform_min_scale&&(n.trigger("pinch",t),n.trigger("pinch"+(1>t.scale?"in":"out"),t));break;case i.EVENT_END:this.triggered&&n.trigger(this.name+"end",t),this.triggered=!1}}},i.gestures.Touch={name:"touch",index:-1/0,defaults:{prevent_default:!1,prevent_mouseevents:!1},handler:function(t,n){return n.options.prevent_mouseevents&&t.pointerType==i.POINTER_MOUSE?(t.stopDetect(),e):(n.options.prevent_default&&t.preventDefault(),t.eventType==i.EVENT_START&&n.trigger(this.name,t),e)}},i.gestures.Release={name:"release",index:1/0,handler:function(t,e){t.eventType==i.EVENT_END&&e.trigger(this.name,t)}},"object"==typeof module&&"object"==typeof module.exports?module.exports=i:(t.Hammer=i,"function"==typeof t.define&&t.define.amd&&t.define("hammer",[],function(){return i}))})(this);
/*! Superslides - v0.6.2 - 2013-07-10
* https://github.com/nicinabox/superslides
* Copyright (c) 2013 Nic Aitch; Licensed MIT */

(function(i,t){var n,e="superslides";n=function(n,e){this.options=t.extend({play:!1,animation_speed:600,animation_easing:"swing",animation:"slide",inherit_width_from:i,inherit_height_from:i,pagination:!0,hashchange:!1,scrollable:!0,elements:{preserve:".preserve",nav:".slides-navigation",container:".slides-container",pagination:".slides-pagination"}},e);var s=this,o=t("<div>",{"class":"slides-control"}),a=1;this.$el=t(n),this.$container=this.$el.find(this.options.elements.container);var r=function(){return a=s._findMultiplier(),s.$el.on("click",s.options.elements.nav+" a",function(i){i.preventDefault(),s.stop(),t(this).hasClass("next")?s.animate("next",function(){s.start()}):s.animate("prev",function(){s.start()})}),t(document).on("keyup",function(i){37===i.keyCode&&s.animate("prev"),39===i.keyCode&&s.animate("next")}),t(i).on("resize",function(){setTimeout(function(){var i=s.$container.children();s.width=s._findWidth(),s.height=s._findHeight(),i.css({width:s.width,left:s.width}),s.css.containers(),s.css.images()},10)}),t(i).on("hashchange",function(){var i,t=s._parseHash();i=t&&!isNaN(t)?s._upcomingSlide(t-1):s._upcomingSlide(t),i>=0&&i!==s.current&&s.animate(i)}),s.pagination._events(),s.start(),s},h={containers:function(){s.init?(s.$el.css({height:s.height}),s.$control.css({width:s.width*a,left:-s.width}),s.$container.css({})):(t("body").css({margin:0}),s.$el.css({position:"relative",overflow:"hidden",width:"100%",height:s.height}),s.$control.css({position:"relative",transform:"translate3d(0)",height:"100%",width:s.width*a,left:-s.width}),s.$container.css({display:"none",margin:"0",padding:"0",listStyle:"none",position:"relative",height:"100%"})),1===s.size()&&s.$el.find(s.options.elements.nav).hide()},images:function(){var i=s.$container.find("img").not(s.options.elements.preserve);i.removeAttr("width").removeAttr("height").css({"-webkit-backface-visibility":"hidden","-ms-interpolation-mode":"bicubic",position:"absolute",left:"0",top:"0","z-index":"-1","max-width":"none"}),i.each(function(){var i=s.image._aspectRatio(this),n=this;if(t.data(this,"processed"))s.image._scale(n,i),s.image._center(n,i);else{var e=new Image;e.onload=function(){s.image._scale(n,i),s.image._center(n,i),t.data(n,"processed",!0)},e.src=this.src}})},children:function(){var i=s.$container.children();i.is("img")&&(i.each(function(){if(t(this).is("img")){t(this).wrap("<div>");var i=t(this).attr("id");t(this).removeAttr("id"),t(this).parent().attr("id",i)}}),i=s.$container.children()),s.init||i.css({display:"none",left:2*s.width}),i.css({position:"absolute",overflow:"hidden",height:"100%",width:s.width,top:0,zIndex:0})}},c={slide:function(i,t){var n=s.$container.children(),e=n.eq(i.upcoming_slide);e.css({left:i.upcoming_position,display:"block"}),s.$control.animate({left:i.offset},s.options.animation_speed,s.options.animation_easing,function(){s.size()>1&&(s.$control.css({left:-s.width}),n.eq(i.upcoming_slide).css({left:s.width,zIndex:2}),i.outgoing_slide>=0&&n.eq(i.outgoing_slide).css({left:s.width,display:"none",zIndex:0})),t()})},fade:function(i,t){var n=this,e=n.$container.children(),s=e.eq(i.outgoing_slide),o=e.eq(i.upcoming_slide);o.css({left:this.width,opacity:1,display:"block"}),i.outgoing_slide>=0?s.animate({opacity:0},n.options.animation_speed,n.options.animation_easing,function(){n.size()>1&&(e.eq(i.upcoming_slide).css({zIndex:2}),i.outgoing_slide>=0&&e.eq(i.outgoing_slide).css({opacity:1,display:"none",zIndex:0})),t()}):(o.css({zIndex:2}),t())}};c=t.extend(c,t.fn.superslides.fx);var d={_centerY:function(i){var n=t(i);n.css({top:(s.height-n.height())/2})},_centerX:function(i){var n=t(i);n.css({left:(s.width-n.width())/2})},_center:function(i){s.image._centerX(i),s.image._centerY(i)},_aspectRatio:function(i){if(!i.naturalHeight&&!i.naturalWidth){var t=new Image;t.src=i.src,i.naturalHeight=t.height,i.naturalWidth=t.width}return i.naturalHeight/i.naturalWidth},_scale:function(i,n){n=n||s.image._aspectRatio(i);var e=s.height/s.width,o=t(i);e>n?o.css({height:s.height,width:s.height/n}):o.css({height:s.width*n,width:s.width})}},l={_setCurrent:function(i){if(s.$pagination){var t=s.$pagination.children();t.removeClass("current"),t.eq(i).addClass("current")}},_addItem:function(i){var n=i+1,e=n,o=s.$container.children().eq(i),a=o.attr("id");a&&(e=a);var r=t("<a>",{href:"#"+e,text:e});r.appendTo(s.$pagination)},_setup:function(){if(s.options.pagination&&1!==s.size()){var i=t("<nav>",{"class":s.options.elements.pagination.replace(/^\./,"")});s.$pagination=i.appendTo(s.$el);for(var n=0;s.size()>n;n++)s.pagination._addItem(n)}},_events:function(){s.$el.on("click",s.options.elements.pagination+" a",function(i){i.preventDefault();var t=s._parseHash(this.hash),n=s._upcomingSlide(t-1);n!==s.current&&s.animate(n,function(){s.start()})})}};return this.css=h,this.image=d,this.pagination=l,this.fx=c,this.animation=this.fx[this.options.animation],this.$control=this.$container.wrap(o).parent(".slides-control"),s._findPositions(),s.width=s._findWidth(),s.height=s._findHeight(),this.css.children(),this.css.containers(),this.css.images(),this.pagination._setup(),r()},n.prototype={_findWidth:function(){return t(this.options.inherit_width_from).width()},_findHeight:function(){return t(this.options.inherit_height_from).height()},_findMultiplier:function(){return 1===this.size()?1:3},_upcomingSlide:function(i){if(/next/.test(i))return this._nextInDom();if(/prev/.test(i))return this._prevInDom();if(/\d/.test(i))return+i;if(i&&/\w/.test(i)){var t=this._findSlideById(i);return t>=0?t:0}return 0},_findSlideById:function(i){return this.$container.find("#"+i).index()},_findPositions:function(i,t){t=t||this,void 0===i&&(i=-1),t.current=i,t.next=t._nextInDom(),t.prev=t._prevInDom()},_nextInDom:function(){var i=this.current+1;return i===this.size()&&(i=0),i},_prevInDom:function(){var i=this.current-1;return 0>i&&(i=this.size()-1),i},_parseHash:function(t){return t=t||i.location.hash,t=t.replace(/^#/,""),t&&!isNaN(+t)&&(t=+t),t},size:function(){return this.$container.children().length},destroy:function(){return this.$el.removeData()},update:function(){this.css.children(),this.css.containers(),this.css.images(),this.pagination._addItem(this.size()),this._findPositions(this.current),this.$el.trigger("updated.slides")},stop:function(){clearInterval(this.play_id),delete this.play_id,this.$el.trigger("stopped.slides")},start:function(){var n=this;n.options.hashchange?t(i).trigger("hashchange"):this.animate(),this.options.play&&(this.play_id&&this.stop(),this.play_id=setInterval(function(){n.animate()},this.options.play)),this.$el.trigger("started.slides")},animate:function(t,n){var e=this,s={};if(!(this.animating||(this.animating=!0,void 0===t&&(t="next"),s.upcoming_slide=this._upcomingSlide(t),s.upcoming_slide>=this.size()))){if(s.outgoing_slide=this.current,s.upcoming_position=2*this.width,s.offset=-s.upcoming_position,("prev"===t||s.outgoing_slide>t)&&(s.upcoming_position=0,s.offset=0),e.size()>1&&e.pagination._setCurrent(s.upcoming_slide),e.options.hashchange){var o=s.upcoming_slide+1,a=e.$container.children(":eq("+s.upcoming_slide+")").attr("id");i.location.hash=a?a:o}e.$el.trigger("animating.slides",[s]),e.animation(s,function(){e._findPositions(s.upcoming_slide,e),"function"==typeof n&&n(),e.animating=!1,e.$el.trigger("animated.slides"),e.init||(e.$el.trigger("init.slides"),e.init=!0,e.$container.fadeIn("fast"))})}}},t.fn[e]=function(i,s){var o=[];return this.each(function(){var a,r,h;return a=t(this),r=a.data(e),h="object"==typeof i&&i,r||(o=a.data(e,r=new n(this,h))),"string"==typeof i&&(o=r[i],"function"==typeof o)?o=o.call(r,s):void 0}),o},t.fn[e].fx={}})(this,jQuery);
/*jshint unused:false */
/**
 * MIT License
 * Copyright(c) 2015 essoduke.org
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED 『AS IS』, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * jQuery tinyMap 輕鬆建立 Google Maps 的 jQuery 擴充套件
 * 拯救眾生免於 Google Maps API 的摧殘，輕鬆就能建立 Google 地圖的 jQuery Plugin。
 *
 * @author Essoduke Chang
 * @version 3.2.0 BETA 9
 * {@link http://app.essoduke.org/tinyMap/}
 *
 * [Changelog]
 * 變更 已不需手動引入 Google Maps API 以及 markerclusterer.js。
 * 新增 direction 原生 API 屬性的支援。
 * 新增 direction.waypoint.icon 屬性，讓每個中繼點都能設置不同的圖示。
 * 新增 instance.getDirectionsInfo 方法可取得地圖上所有路徑規劃的資訊（距離、時間）。
 * 新增 geolocation 參數以設置 navigator.geolocation。
 * 新增 Places Service API。
 * 新增 marker.cluster 參數可設置該標記是否加入叢集。
 * 新增 kml 支援原生屬性。
 * 新增 $.fn.tinyMapQuery 公用方法可轉換地址（經緯座標）為經緯座標（地址）。
 * 新增 $.fn.tinyMapDistance 公用方法可計算多個地點之間的距離。
 * 新增 clear 方法可指定欲清除的圖層 ID 或順序編號。
 * 修正 destroy 沒有作用的問題。
 * 修正 markerCluster 無法設置 maxZoom, gridSize... 等原生屬性的問題。
 *
 * Last Modified 2015.05.21.121158
 */
// Call while google maps api loaded
window.gMapsCallback = function () {
    $(window).trigger('gMapsCallback');
};
// Plugins statement
;(function ($, window, document, undefined) {

    // API Configure
    var apiLoaded = false,
        apiClusterLoaded = false,
        tinyMapConfigure = {
            'sensor'   : false,
            'language' : 'zh-TW',
            'callback' : 'gMapsCallback',
            'api'      : '//maps.google.com/maps/api/js',
            'clusterer': '//google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/markerclusterer_compiled.js'
        },
        // Default plugin settings
        defaults = {
            'autoLocation': false,
            'center': [24, 121],
            'infoWindowAutoClose': true,
            'interval': 200,
            'loading': '讀取中&hellip;',
            'notFound': '找不到查詢的地點',
            'zoom': 8
        },
        styles = {},
        Label = {};

    //#!#START STYLES
    styles = {
        // Grey Scale
        'greyscale': [{
            'featureType': 'all',
            'stylers': [
                {'saturation': -100},
                {'gamma': 0.5}
            ]
        }]
    };
    //#!#END
    /**
     * Parsing the location
     * @param {(string|Array|Object)} loc Location
     * @param {boolean} formatting Format to Google Maps LatLng object
     * @return {Object}
     */
    function parseLatLng (loc, formatting) {
        var array = [],
            re = /^[+-]?\d+(\.\d+)?$/,
            result = {
                'lat': '',
                'lng': ''
            };
        if ('string' === typeof loc || Array.isArray(loc)) {
            array = Array.isArray(loc) ? loc : loc.toString().replace(/\s+/, '').split(',');
            if (2 === array.length) {
                if (re.test(array[0]) && re.test(array[1])) {
                    result.lat = array[0];
                    result.lng = array[1];
                }
            } else {
                return loc;
            }
        } else if ('object' === typeof loc) {
            // Google LatLng Class
            if ('function' === typeof loc.lat) {
                return loc;
            } else if (loc.hasOwnProperty('x') && loc.hasOwnProperty('y')) {
                result.lat = loc.x;
                result.lng = loc.y;
            } else if (loc.hasOwnProperty('lat') && loc.hasOwnProperty('lng')) {
                result.lat = loc.lat;
                result.lng = loc.lng;
            }
        }
        if (true === formatting) {
            return new google.maps.LatLng(result.lat, result.lng);
        }
        return result;
    }

    /**
     * tinyMap Constructor
     * @param {Object} container HTML element
     * @param {(Object|string)} options User settings
     * @constructor
     */
    function TinyMap (container, options) {

        var self = this,
            opt = $.extend({}, defaults, options);

        /**
         * Map instance
         * @type {Object}
         */
        self.map = null;
        /**
         * Map markers
         * @type {Object}
         */
        self._markers = [];
        /**
         * Map markers
         * @type {Object}
         */
        self._markersCluster = [];
        /**
         * Map markers clusterer
         * @type {Object}
         */
        self._clusters = [];
        /**
         * Map Labels
         * @type {Object}
         */
        self._labels = [];
        /**
         * Polylines layer
         * @type {Object}
         */
        self._polylines = [];
        /**
         * Polygons layer
         * @type {Object}
         */
        self._polygons = [];
        /**
         * Circles layer
         * @type {Object}
         */
        self._circles = [];
        /**
         * KML layer
         * @type {Object}
         */
        self._kmls = [];
        /**
         * Directions layer
         * @type {Object}
         */
        self._directions = [];
        /**
         * Directions icon layer
         * @type {Object}
         */
        self._directionsMarkers = [];
        /**
         * DOM of selector
         * @type {Object}
         */
        self._places = [];
        /**
         * DOM of selector
         * @type {Object}
         */
        self.container = container;
        /**
         * Merge the options
         * @type {Object}
         */
        self.options = opt;
        /**
         * Google Map options
         * @type {Object}
         */
        self.googleMapOptions = {};
        /**
         * Interval for geocoder's query interval
         * @type {number}
         */
        self.interval = parseInt(self.options.interval, 10) || 200;
        /**
         * Binding callback event for API async
         */
        $(window).on('gMapsCallback', function () {
            self.init();
        });
        $(this.container).html(opt.loading);
        // Call initialize
        self.init();
    }
    /**
     * tinyMap prototype
     */
    TinyMap.prototype = {

        VERSION: '3.2.0 BETA 9',

        // Google Maps LatLngBounds
        bounds: {},

        /**
         * Overlay process
         * @this {tinyMap}
         */
        overlay: function () {
            var map = this.map,
                opt = this.options;
            try {
                //#!#START KML
                // kml overlay
                this.kml(map, opt);
                //#!#END
                //#!#START DIRECTION
                // direction overlay
                this.direction(map, opt);
                //#!#END
                //#!#START MARKER
                // markers overlay
                this.markers(map, opt);
                //#!#END
                //#!#START POLYLINE
                // polyline overlay
                this.drawPolyline(map, opt);
                //#!#END
                //#!#START POLYGON
                // polygon overlay
                this.drawPolygon(map, opt);
                //#!#END
                //#!#START CIRCLE
                // circle overlay
                this.drawCircle(map, opt);
                //#!#END
                //#!#START STREETVIEW
                // StreetView service
                this.streetView(map, opt);
                //#!#END
                //#!#START PLACES
                // PlaceService
                this.places(map, opt);
                //#!#END
                // GeoLocation
                this.geoLocation(map, opt);
            } catch (ignore) {
                console.info(ignore);
            }
        },
        /**
         * Events binding
         * @param {Object} marker Marker objects
         * @param {(function|Object)} event Events
         * @this {tinyMap}
         */
        bindEvents: function (target, event) {
            var self = this,
                e = {};
            switch (typeof event) {
            case 'function':
                google.maps.event.addListener(target, 'click', event);
                break;
            case 'object':
                for (e in event) {
                    if ('function' === typeof event[e]) {
                        google.maps.event.addListener(target, e, event[e]);
                    } else {
                        if (event[e].hasOwnProperty('func') && 'function' === typeof event[e].func) {
                            if (event[e].hasOwnProperty('once') && true === event[e].once) {
                                google.maps.event.addListenerOnce(target, e, event[e].func);
                            } else {
                                google.maps.event.addListener(target, e, event[e].func);
                            }
                        } else if ('function' === typeof event[e]) {
                            google.maps.event.addListener(target, e, event[e]);
                        }
                    }
                }
                break;
            default:
                return;
            }
            if (target.hasOwnProperty('infoWindow')) {
                google.maps.event.addListener(target, 'click', function () {
                    var i = 0,
                        m = {};
                    // Close all infoWindows if `infoWindowAutoClose` was true.
                    if (self.options.hasOwnProperty('infoWindowAutoClose') &&
                        true === self.options.infoWindowAutoClose
                    ) {
                        for (i = self._markers.length - 1; i >= 0; i -= 1) {
                            m = self._markers[i];
                            if (m.hasOwnProperty('infoWindow') && 'function' === typeof m.infoWindow.close) {
                                m.infoWindow.close();
                            }
                        }
                    }
                    target.infoWindow.open(self.map, target);
                });
            }
        },
        //#!#START KML
        /**
         * KML overlay
         * @param {Object} map Map instance
         * @param {Object} opt KML options
         */
        kml: function (map, opt) {
            var self = this,
                kml = {},
                kmlOpt = {
                    'url': '',
                    'map': map,
                    'preserveViewport': false,
                    'suppressInfoWindows': false
                },
                i = 0;

            if (opt.hasOwnProperty('kml')) {
                if ('string' === typeof opt.kml) {
                    kmlOpt.url = opt.kml;
                    kml = new google.maps.KmlLayer(kmlOpt);
                    this._kmls.push(kml);
                } else if (Array.isArray(opt.kml)) {
                    for (i = opt.kml.length - 1; i >= 0; i -= 1) {
                        if ('string' === typeof opt.kml[i]) {
                            kmlOpt.url = opt.kml[i];
                            kml = new google.maps.KmlLayer(kmlOpt);
                        } else if ('object' === typeof opt.kml[i]) {
                            kmlOpt = $.extend({}, kmlOpt, opt.kml[i]);
                            kml = new google.maps.KmlLayer(kmlOpt);
                            if (kmlOpt.hasOwnProperty('event')) {
                                self.bindEvents(kml, kmlOpt.event);
                            }
                        }
                        this._kmls.push(kml);
                    }
                }
            }
        },
        //#!#END
        //#!#START POLYLINE
        //begin add Multiple POLYLINE by Karry
        /**
         * Polyline overlay
         * @param {Object} map Map instance
         * @param {Object} opt Polyline options
         */
        drawPolyline: function (map, opt) {

            var self = this,
                c = {},
                i = 0,
                p = {},
                c1 = 0,
                path = [],
                defOpt = {},
                coords = [],
                service = {},
                polyline = {},
                distance = {},
                polylineX = {},
                waypoints = [];

                // Route callback
                routeCallback = function (result, status) {
                    if (status === google.maps.DirectionsStatus.OK) {
                        for (i = result.routes[0].overview_path.length - 1; i >= 0; i -= 1) {
                            path.push(result.routes[0].overview_path[i]);
                        }
                        polyline.setPath(path);
                        if ('function' === typeof polylineX.getDistance) {
                            distance = result.routes[0].legs[0].distance;
                            polylineX.getDistance.call(this, distance);
                        }
                    }
                };

            if (opt.hasOwnProperty('polyline') && Array.isArray(opt.polyline)) {
                for (c1 = opt.polyline.length - 1; c1 >= 0; c1 -= 1) {
                    polylineX = opt.polyline[c1];
                    if (polylineX.hasOwnProperty('coords') &&
                        Array.isArray(polylineX.coords)
                    ) {
                        coords = new google.maps.MVCArray();
                        for (i = polylineX.coords.length - 1; i >= 0; i -= 1) {
                            p = polylineX.coords[i];
                            c = parseLatLng(p, true);
                            if ('function' === typeof c.lat) {
                                coords.push(c);
                            }
                        }
                        // Options merge
                        defOpt = $.extend({}, {
                            'strokeColor'  : polylineX.color || '#FF0000',
                            'strokeOpacity': polylineX.opacity || 1.0,
                            'strokeWeight' : polylineX.width || 2
                        }, polylineX);

                        polyline = new google.maps.Polyline(defOpt);
                        this._polylines.push(polyline);

                        if (2 < coords.getLength()) {
                            for (i = coords.length - 1; i >= 0; i -= 1) {
                                if (0 < i && (coords.length - 1 > i)) {
                                    waypoints.push({
                                        'location': coords.getAt(i),
                                        'stopover': false
                                    });
                                }
                            }
                        }
                        // Events binding
                        if (polylineX.hasOwnProperty('event')) {
                            self.bindEvents(polyline, polylineX.event);
                        }

                        if (polylineX.hasOwnProperty('snap') &&
                            true === polylineX.snap
                        ) {
                            service = new google.maps.DirectionsService();
                            service.route({
                                'origin': coords.getAt(0),
                                'waypoints': waypoints,
                                'destination': coords.getAt(coords.length - 1),
                                'travelMode': google.maps.DirectionsTravelMode.DRIVING
                            }, routeCallback);
                        } else {
                            polyline.setPath(coords);
                            if (google.maps.hasOwnProperty('geometry') &&
                                google.maps.geometry.hasOwnProperty('spherical')
                            ) {
                                if ('function' === typeof google.maps.geometry.spherical.computeDistanceBetween) {
                                    distance = google.maps
                                                     .geometry
                                                     .spherical
                                                     .computeDistanceBetween(
                                                         coords.getAt(0),
                                                         coords.getAt(coords.length - 1)
                                                     );
                                    if ('function' === typeof polylineX.getDistance) {
                                        polylineX.getDistance.call(this, distance);
                                    }
                                }
                            }
                        }
                        polyline.setMap(map);
                    }
                }
            }
        },
        //add Multiple POLYLINE by karry
        //#!#END
        //#!#START POLYGON
        /**
         * Polygon overlay
         * @param {Object} map Map instance
         * @param {Object} opt Polygon options
         */
        drawPolygon: function (map, opt) {
            var self = this,
                polygon = {},
                i = 0,
                j = 0,
                p = {},
                c = {},
                len = 0,
                defOpt = {},
                coords = [];

            if (opt.hasOwnProperty('polygon') && Array.isArray(opt.polygon)) {
                for (i = opt.polygon.length - 1; i >= 0; i -= 1) {
                    coords = [];
                    if (opt.polygon[i].hasOwnProperty('coords')) {
                        for (j = opt.polygon[i].coords.length - 1; j >= 0; j -= 1) {
                            p = opt.polygon[i].coords[j];
                            c = parseLatLng(p, true);
                            if ('function' === typeof c.lat) {
                                coords.push(c);
                            }
                        }
                        defOpt = $.extend({}, {
                            'path': coords,
                            'strokeColor': opt.polygon[i].color || '#FF0000',
                            'strokeOpacity': 1.0,
                            'strokeWeight': opt.polygon[i].width || 2,
                            'fillColor': opt.polygon[i].fillcolor || '#CC0000',
                            'fillOpacity': 0.35
                        }, opt.polygon[i]);
                        polygon = new google.maps.Polygon(defOpt);
                        if (opt.polygon[i].hasOwnProperty('event')) {
                            self.bindEvents(polygon, opt.polygon[i].event);
                        }
                        self._polygons.push(polygon);
                        polygon.setMap(map);
                    }
                }
            }
        },
        //#!#END
        //#!#START CIRCLE
        /**
         * Circle overlay
         * @param {Object} map Map instance
         * @param {Object} opt Circle options
         */
        drawCircle: function (map, opt) {
            var self = this,
                c = 0,
                loc = {},
                defOpt = {},
                circle = {},
                circles = {};

            if (opt.hasOwnProperty('circle') && Array.isArray(opt.circle)) {
                for (c = opt.circle.length - 1; c >= 0; c -= 1) {
                    circle = opt.circle[c];
                    defOpt = $.extend({}, {
                        'map': map,
                        'strokeColor': circle.color || '#FF0000',
                        'strokeOpacity': circle.opacity || 0.8,
                        'strokeWeight': circle.width || 2,
                        'fillColor': circle.fillcolor || '#FF0000',
                        'fillOpacity': circle.fillopacity || 0.35,
                        'radius': circle.radius || 10,
                        'zIndex': 100,
                        'id' : circle.hasOwnProperty('id') ? circle.id : ''
                    }, circle);
                    if (circle.hasOwnProperty('center')) {
                        loc = parseLatLng(circle.center, true);
                        defOpt.center = loc;
                    }
                    if ('function' === typeof loc.lat) {
                        circles = new google.maps.Circle(defOpt);
                        self._circles.push(circles);
                        if (circle.hasOwnProperty('event')) {
                            self.bindEvents(circles, circle.event);
                        }
                    }
                }
            }
        },
        //#!#END
        //#!#START MARKER
        /**
         * Markers overlay
         * @param {Object} map Map instance
         * @param {Object} opt Markers options
         */
        markers: function (map, opt, source) {

            if (!opt.hasOwnProperty('marker') || !Array.isArray(opt.marker)) {
                return false;
            }

            var self = this,
                m = {},
                i = 0,
                j = 0,
                loc = {},
                markers  = self._markers,
                labels   = self._labels,
                geocoder = new google.maps.Geocoder(),
                // Geocoder callback
                geocodeCallback = function (results, status) {
                    if (status === google.maps.GeocoderStatus.OK) {
                        markers[j].setPosition(results[0].geometry.location);
                    } else {
                        throw 'Geocoder Status: ' + status;
                    }
                };

            // For first initialize of instance.
            if ((!source || 0 === markers.length)) {
                for (i = 0; i < opt.marker.length; i += 1) {
                    m = opt.marker[i];
                    if (m.hasOwnProperty('addr')) {
                        m.parseAddr = parseLatLng(m.addr, true);
                        if ('string' === typeof m.parseAddr) {
                            self.markerByGeocoder(map, m, opt);
                        } else {
                            self.markerDirect(map, m, opt);
                        }
                    }
                }
                source = undefined;
            }

            // Modify markers
            if ('modify' === source) {
                for (i = 0; i < opt.marker.length; i += 1) {
                    if (opt.marker[i].hasOwnProperty('id')) {
                        for (j = 0; j < markers.length; j += 1) {
                            if (opt.marker[i].id === markers[j].id &&
                                opt.marker[i].hasOwnProperty('addr')
                            ) {
                                // Fix the marker which has `id` and `addr`
                                // will disappear when call the modify.
                                // @since v3.1.6
                                loc = parseLatLng(opt.marker[i].addr, true);
                                if ('string' === typeof loc) {
                                    geocoder.geocode({'address': loc}, geocodeCallback);
                                } else {
                                    markers[j].setPosition(loc);
                                }
                                if (opt.marker[i].hasOwnProperty('text')) {
                                    if (markers[j].hasOwnProperty('infoWindow')) {
                                        if ('function' === typeof markers[j].infoWindow.setContent) {
                                            markers[j].infoWindow.setContent(opt.marker[i].text);
                                        }
                                    } else {
                                        markers[j].infoWindow = new google.maps.InfoWindow({
                                            'content': opt.marker[i].text
                                        });
                                        self.bindEvents(markers[j], opt.marker[i].event);
                                    }
                                }
                                if (opt.marker[i].hasOwnProperty('icon')) {
                                    markers[j].setIcon(opt.marker[i].icon);
                                }
                            // Insert if the forceInsert was true when
                            // id property was not matched.
                            // @since v3.1.2
                            } else {
                                if (opt.marker[i].hasOwnProperty('forceInsert') &&
                                    opt.marker[i].forceInsert === true &&
                                    opt.marker[i].hasOwnProperty('addr')) {
                                    opt.marker[i].parseAddr = parseLatLng(opt.marker[i].addr, true);
                                    if ('string' === typeof opt.marker[i].parseAddr) {
                                        self.markerByGeocoder(map, opt.marker[i], opt);
                                    } else {
                                        self.markerDirect(map, opt.marker[i]);
                                    }
                                    break;
                                }
                            }
                        }
                    }  else {
                        if (opt.marker[i].hasOwnProperty('addr')) {
                            opt.marker[i].parseAddr = parseLatLng(opt.marker[i].addr, true);
                            if ('string' === typeof opt.marker[i].parseAddr) {
                                self.markerByGeocoder(map, opt.marker[i]);
                            } else {
                                self.markerDirect(map, opt.marker[i]);
                            }
                        }
                    }
                    // Re-drawing the labels
                    for (j = 0; j < labels.length; j += 1) {
                        if (opt.marker[i].id === labels[j].id) {
                            if (opt.marker[i].hasOwnProperty('label')) {
                                labels[j].text = opt.marker[i].label;
                            }
                            if (opt.marker[i].hasOwnProperty('css')) {
                                $(labels[j].span).addClass(opt.marker[i].css);
                            }
                            labels[j].draw();
                        }
                    }
                }
            }
        },
        /**
         * Build the icon options of marker
         * @param {Object} opt Marker option
         * @this {tinyMap}
         */
        markerIcon: function (opt) {
            var icons = $.extend({}, opt.icon);
            if (opt.hasOwnProperty('icon')) {
                if ('string' === typeof opt.icon) {
                    return opt.icon;
                }
                if (opt.icon.hasOwnProperty('url')) {
                    icons.url = opt.icon.url;
                }
                if (opt.icon.hasOwnProperty('size')) {
                    if (Array.isArray(opt.icon.size) &&
                        2 === opt.icon.size.length
                    ) {
                        icons.size = new google.maps.Size(
                            opt.icon.size[0],
                            opt.icon.size[1]
                        );
                    }
                }
                if (opt.icon.hasOwnProperty('scaledSize')) {
                    if (Array.isArray(opt.icon.scaledSize) &&
                        2 === opt.icon.scaledSize.length
                    ) {
                        icons.scaledSize = new google.maps.Size(
                            opt.icon.scaledSize[0],
                            opt.icon.scaledSize[1]
                        );
                    }
                }
                if (opt.icon.hasOwnProperty('anchor')) {
                    if (Array.isArray(opt.icon.anchor) &&
                        2 === opt.icon.anchor.length
                    ) {
                        icons.anchor = new google.maps.Point(
                            opt.icon.anchor[0],
                            opt.icon.anchor[1]
                        );
                    }
                }
            }
            return icons;
        },
        /**
         * Set a marker directly by latitude and longitude
         * @param {Object} opt Options
         * @this {tinyMap}
         */
        markerDirect: function (map, opt) {
            var self    = this,
                marker  = {},
                label   = {},
                id      = opt.hasOwnProperty('id') ? opt.id : '',
                title   = opt.hasOwnProperty('title') ?
                          opt.title.toString().replace(/<([^>]+)>/g, '') :
                          false,
                content = opt.hasOwnProperty('text') ? opt.text.toString() : false,
                icons   = self.markerIcon(opt),
                clusterOption = {
                    'maxZoom': null,
                    'gridSize': 60
                },
                markerOptions = $.extend({}, {
                    'map': map,
                    'position': opt.parseAddr,
                    'animation': null,
                    'id': id
                }, opt);

            if (title) {
                markerOptions.title = title;
            }
            if (content) {
                markerOptions.text = content;
                markerOptions.infoWindow = new google.maps.InfoWindow({
                    'content': content
                });
            }
            if (!$.isEmptyObject(icons)) {
                markerOptions.icon = icons;
            }
            if (opt.hasOwnProperty('animation') && 'string' === typeof opt.animation) {
                markerOptions.animation = google.maps.Animation[opt.animation.toUpperCase()];
            }

            marker = new google.maps.Marker(markerOptions);
            self._markers.push(marker);

            // Apply marker fitbounds
            if (marker.hasOwnProperty('position')) {
                if ('function' === typeof marker.getPosition) {
                    self.bounds.extend(marker.position);
                }
                if (self.options.hasOwnProperty('markerFitBounds') &&
                    true === self.options.markerFitBounds
                ) {
                    // Make sure fitBounds call after the last marker created.
                    if (self._markers.length === self.options.marker.length) {
                        map.fitBounds(self.bounds);
                    }
                }
            }
            /**
             * Apply marker cluster.
             * Require markerclusterer.js
             * @see {@link http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/}
             * @since 2015-04-30 10:18:33
             */
            if (!opt.hasOwnProperty('cluster') || (opt.hasOwnProperty('cluster') && true === opt.cluster)) {
                self._markersCluster.push(marker);
            }
            if (self.options.hasOwnProperty('markerCluster')) {
                if ('function' === typeof MarkerClusterer) {
                    clusterOption = $.extend({}, clusterOption, self.options.markerCluster);
                    if (self._markers.length === self.options.marker.length) {
                        self._clusters.push(new MarkerClusterer(map, self._markersCluster, clusterOption));
                    }
                }
            }

            if (opt.hasOwnProperty('label')) {
                label = new Label({
                    'text': opt.label,
                    'map' : map,
                    'css' : opt.hasOwnProperty('css') ? opt.css.toString() : '',
                    'id'  :  id
                });
                label.bindTo('position', marker, 'position');
                label.bindTo('text', marker, 'position');
                label.bindTo('visible', marker);
                self._labels.push(label);
            }
            // Binding events
            self.bindEvents(marker, opt.event);
        },
        /**
         * Set a marker by Geocoder service
         * @param {Object} opt Options
         * @this {tinyMap}
         */
        markerByGeocoder: function (map, opt, def) {
            var geocoder = new google.maps.Geocoder(),
                self = this;
            geocoder.geocode({'address': opt.parseAddr}, function (results, status) {
                // If exceeded, call it later by setTimeout;
                if (status === google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                    window.setTimeout(function () {
                        self.markerByGeocoder(map, opt);
                    }, self.interval);
                } else if (status === google.maps.GeocoderStatus.OK) {
                    var marker = {},
                        label = {},
                        id    = opt.hasOwnProperty('id') ? opt.id : '',
                        title = opt.hasOwnProperty('title') ?
                                opt.title.toString().replace(/<([^>]+)>/g, '') :
                                false,
                        content = opt.hasOwnProperty('text') ? opt.text.toString() : false,
                        clusterOption = {
                            'maxZoom': null,
                            'gridSize': 60
                        },
                        markerOptions = {
                            'map': map,
                            'position': results[0].geometry.location,
                            'animation': null,
                            'id': id
                        },
                        icons = self.markerIcon(opt);

                    if (title) {
                        markerOptions.title = title;
                    }
                    if (content) {
                        markerOptions.text = content;
                        markerOptions.infoWindow = new google.maps.InfoWindow({
                            'content': content
                        });
                    }
                    if (!$.isEmptyObject(icons)) {
                        markerOptions.icon = icons;
                    }
                    if (opt.hasOwnProperty('animation') && 'string' === typeof opt.animation) {
                        markerOptions.animation = google.maps.Animation[opt.animation.toUpperCase()];
                    }

                    markerOptions = $.extend({}, markerOptions, opt);
                    marker = new google.maps.Marker(markerOptions);
                    self._markers.push(marker);

                    // Apply marker fitbounds
                    if (marker.hasOwnProperty('position')) {
                        if ('function' === typeof marker.getPosition) {
                            self.bounds.extend(marker.position);
                        }
                        if (self.options.hasOwnProperty('markerFitBounds') &&
                            true === self.options.markerFitBounds
                        ) {
                            // Make sure fitBounds call after the last marker created.
                            // @since v3.1.7
                            if (self._markers.length === def.marker.length) {
                                map.fitBounds(self.bounds);
                            }
                        }
                    }
                    /**
                     * Apply marker cluster.
                     * Require markerclusterer.js
                     * @see {@link http://google-maps-utility-library-v3.googlecode.com/svn/trunk/markerclusterer/src/}
                     * @since 2015-04-30 10:18:33
                     */
                    if (!opt.hasOwnProperty('cluster') || (opt.hasOwnProperty('cluster') && true === opt.cluster)) {
                        self._markersCluster.push(marker);
                    }
                    if (self.options.hasOwnProperty('markerCluster') &&
                        'function' === typeof MarkerClusterer &&
                        self._markers.length === def.marker.length
                    ) {
                        clusterOption = $.extend({}, clusterOption, self.options.markerCluster);
                        self._clusters.push(new MarkerClusterer(map, self._markersCluster, clusterOption));
                    }

                    if (opt.hasOwnProperty('label')) {
                        label = new Label({
                            'text': opt.label,
                            'map' : self.map,
                            'css' : opt.hasOwnProperty('css') ? opt.css.toString() : '',
                            'id'  : id
                        });
                        label.bindTo('position', marker, 'position');
                        label.bindTo('text', marker, 'position');
                        label.bindTo('visible', marker);
                        self._labels.push(label);
                    }
                    // Binding events
                    self.bindEvents(marker, opt.event);
                }
            });
        },
        //#!#END
        //#!#START DIRECTION
        /**
         * Direction overlay
         * @param {Object} map Map instance
         * @param {Object} opt Direction options
         */
        direction: function (map, opt) {
            if (opt.hasOwnProperty('direction') && Array.isArray(opt.direction)) {
                for (var d = opt.direction.length - 1; d >= 0; d -= 1) {
                    this.directionService(opt.direction[d]);
                }
            }
        },
        /**
         * Direction service
         * @param {Object} opt Options
         * @this {tinyMap}
         */
        directionService: function (opt) {

            // Make sure the `from` and `to` properties has setting.
            if (!(opt.hasOwnProperty('from') && opt.hasOwnProperty('to'))) {
                return;
            }

            var self = this,
                directionsService = new google.maps.DirectionsService(),
                directionsDisplay = new google.maps.DirectionsRenderer(),
                request = {
                    'travelMode': google.maps.DirectionsTravelMode.DRIVING,
                    'optimizeWaypoints': opt.hasOwnProperty('optimize') ? opt.optimize : true
                },
                infoWindow = new google.maps.InfoWindow(),
                renderOpts = {},
                waypoints  = [],
                waypointsOpts = {},
                waypointsText = [],
                waypointsIcon = [],
                startText = '',
                endText = '',
                i = 0;

            request.origin = parseLatLng(opt.from, true);
            request.destination = parseLatLng(opt.to, true);
            renderOpts = $.extend({}, {
                'infoWindow': infoWindow,
                'map': self.map
            }, opt);

            if (opt.hasOwnProperty('travel') &&
                google.maps.TravelMode[opt.travel.toString().toUpperCase()]
            ) {
                request.travelMode = google.maps.TravelMode[opt.travel.toString().toUpperCase()];
            }

            if (opt.hasOwnProperty('panel') && $(opt.panel).length) {
                renderOpts.panel = $(opt.panel).get(0);
            }

            if (opt.hasOwnProperty('waypoint') && Array.isArray(opt.waypoint)) {
                for (i = opt.waypoint.length - 1; i >= 0; i -= 1) {
                    waypointsOpts = {};
                    if ('string' === typeof opt.waypoint[i] || Array.isArray(opt.waypoint[i])) {
                        waypointsOpts = {
                            'location': parseLatLng(opt.waypoint[i], true),
                            'stopover': true
                        };
                    } else {
                        if (opt.waypoint[i].hasOwnProperty('location')) {
                            waypointsOpts.location = parseLatLng(opt.waypoint[i].location, true);
                        }
                        waypointsOpts.stopover = opt.waypoint[i].hasOwnProperty('stopover') ?
                                                 opt.waypoint[i].stopover :
                                                 true;
                    }
                    waypointsText.push(opt.waypoint[i].text || opt.waypoint[i].toString());
                    if (opt.waypoint[i].hasOwnProperty('icon')) {
                        waypointsIcon.push(opt.waypoint[i].icon.toString());
                    }
                    waypoints.push(waypointsOpts);
                }
                request.waypoints = waypoints;
            }
            // direction service
            directionsService.route(request, function (response, status) {
                var legs = [],
                    wp = {},
                    i = 0;
                if (status === google.maps.DirectionsStatus.OK) {
                    legs = response.routes[0].legs;
                    try {
                        if (opt.hasOwnProperty('fromText')) {
                            legs[0].start_address = opt.fromText;
                            startText = opt.fromText;
                        }
                        if (opt.hasOwnProperty('toText')) {
                            if (1 === legs.length) {
                                legs[0].end_address = opt.toText;
                            } else {
                                legs[legs.length - 1].end_address = opt.toText;
                            }
                            endText = opt.toText;
                        }
                        if (opt.hasOwnProperty('icon')) {
                            renderOpts.suppressMarkers = true;
                            if (opt.icon.hasOwnProperty('from') && 'string' === typeof opt.icon.from) {
                                self.directionServiceMarker(legs[0].start_location, {
                                    'icon': opt.icon.from,
                                    'text': startText
                                }, infoWindow, opt);
                            }
                            if (opt.icon.hasOwnProperty('to') && 'string' === typeof opt.icon.to) {
                                self.directionServiceMarker(legs[legs.length - 1].end_location, {
                                    'icon': opt.icon.to,
                                    'text': endText
                                }, infoWindow, opt);
                            }
                        }
                        for (i = legs.length - 1; i >= 0; i -= 1) {
                            if (opt.hasOwnProperty('icon')) {
                                if (opt.icon.hasOwnProperty('waypoint') && 'string' === typeof opt.icon.waypoint) {
                                    wp.icon = opt.icon.waypoint;
                                } else if ('string' === typeof waypointsIcon[i - 1]) {
                                    wp.icon = waypointsIcon[i - 1];
                                }
                                wp.text = waypointsText[i - 1];
                                self.directionServiceMarker(legs[i].start_location, wp, infoWindow, opt);
                            }
                        }
                    } catch (ignore) {
                    }
                    self.bindEvents(directionsDisplay, opt.event);
                    directionsDisplay.setOptions(renderOpts);
                    directionsDisplay.setDirections(response);
                }
            });
            self._directions.push(directionsDisplay);
        },
        /**
         * Create the marker for directions
         * @param {Object} loc LatLng Location
         * @param {Object} opt MarkerOptions
         * @param {Object} info Global infoWindow object
         */
        directionServiceMarker: function (loc, opt, info, d) {
            var self = this,
                evt = {},
                setting = $.extend({}, {
                    'position': loc,
                    'map': self.map,
                    'id' : d.hasOwnProperty('id') ? d.id : ''
                }, opt),
                marker  = new google.maps.Marker(setting);
            if (setting.hasOwnProperty('text')) {
                evt = function () {
                    info.setPosition(loc);
                    info.setContent(setting.text);
                    info.open(self.map, marker);
                };
            }
            self._directionsMarkers.push(marker);
            self.bindEvents(marker, evt);
        },
        /**
         * Get directions info
         * @return {Array} All directions info includes distance and duration.
         */
        getDirectionsInfo: function () {
            var self   = this,
                dr     = self._directions,
                i      = 0,
                j      = 0,
                ci     = 0,
                cj     = 0,
                leg    = null,
                result = [];

            if (dr) {
                for (i = 0, ci = dr.length; i < ci; i += 1) {
                    if (
                        dr[i].hasOwnProperty('directions') &&
                        dr[i].directions.hasOwnProperty('routes') &&
                        undefined !== dr[i].directions.routes[0].legs
                    ) {
                        leg = dr[i].directions.routes[0].legs;
                        result[i] = [];
                        for (j = 0, cj = leg.length; j < cj; j += 1) {
                            result[i].push({
                                'from': leg[j].start_address,
                                'to'  : leg[j].end_address,
                                'distance': leg[j].distance,
                                'duration': leg[j].duration
                            });
                        }
                    }
                }
            }
            return result;
        },
        //#!#END
        //#!#START STREETVIEW
        /**
         * Switch StreetView
         * @this {tinyMap}
         */
        streetView: function (map, opt) {
            var self = this,
                pano = {},
                opts = opt.hasOwnProperty('streetViewObj') ? opt.streetViewObj : {},
                loc  = {};

            if ('function' === typeof map.getStreetView && opt.hasOwnProperty('streetViewObj')) {
                pano = map.getStreetView();
                // Default position of streetView
                if (opts.hasOwnProperty('position')) {
                    loc = parseLatLng(opts.position, true);
                    opts.position = 'object' === typeof loc ? map.getCenter() : loc;
                } else {
                    opts.position = map.getCenter();
                }
                // Pov configure
                if (opts.hasOwnProperty('pov')) {
                    opts.pov = $.extend({}, {
                        'heading': 0,
                        'pitch'  : 0,
                        'zoom'   : 1
                    }, opts.pov);
                }
                if (opts.hasOwnProperty('visible')) {
                    pano.setVisible(opts.visible);
                }
                // Apply options
                pano.setOptions(opts);
                // Events Binding
                if (opts.hasOwnProperty('event')) {
                    self.bindEvents(pano, opts.event);
                }
            }
        },
        //#!#END
        //#!#START PLACES
        /**
         * Places API
         * @this {tinyMap}
         */
        places: function (map, opt) {
            var self = this,
                reqOpt = opt.hasOwnProperty('places') ? opt.places : {},
                request = $.extend({}, {
                    'location': map.getCenter(),
                    'radius'  : 100
                }, reqOpt),
                placesService = {},
                i = 0;
            if (undefined !== google.maps.places && request.hasOwnProperty('query')) {
                placesService = new google.maps.places.PlacesService(map),
                placesService.textSearch(request, function (results, status) {
                    if (status === google.maps.places.PlacesServiceStatus.OK) {
                        self.places = results;
                        if (request.hasOwnProperty('createMarker') && true === request.createMarker) {
                            for (i = results.length - 1; i >= 0; i -= 1) {
                                if (results[i].hasOwnProperty('geometry')) {
                                    self._markers.push(new google.maps.Marker({
                                        'map': map,
                                        'position': results[i].geometry.location
                                    }));
                                }
                            }
                        }
                    }
                });
            }
        },
        //#!#END
        /**
         * Use HTML5 Geolocation API to detect the client's location.
         * @param {Object} map Map intance
         * @param {Object} opt Plugin options
         */
        geoLocation: function (map, opt) {
            try {
                var geolocation = navigator.geolocation,
                    geoOpt = {};

                if (!geolocation) {
                    return;
                }
                if (opt.hasOwnProperty('geolocation')) {
                    geoOpt = $.extend({}, {
                        'maximumAge': 600000,
                        'timeout': 3000,
                        'enableHighAccuracy': false
                    }, opt.geolocation);
                }
                if (true === opt.autoLocation) {
                    geolocation.getCurrentPosition(
                        function (loc) {
                            if (loc && loc.hasOwnProperty('coords') &&
                                loc.coords.hasOwnProperty('latitude') &&
                                loc.coords.hasOwnProperty('longitude')
                            ) {
                                map.panTo(new google.maps.LatLng(
                                    loc.coords.latitude, loc.coords.longitude
                                ));
                            }
                        },
                        function (error) {
                            console.error(error);
                        },
                        geoOpt
                    );
                }
            } catch (ignore) {
            }
        },
        //#!#START PANTO
        /**
         * Method: Google Maps PanTo
         * @param {(string|Array|Object)} addr Location
         * @public
         */
        panTo: function (addr) {
            var m = this.map,
                loc = {},
                geocoder = {};

            if (null !== m && undefined !== m) {
                loc = parseLatLng(addr, true);
                if ('string' === typeof loc) {
                    geocoder = new google.maps.Geocoder();
                    geocoder.geocode({'address': loc}, function (results, status) {
                        if (status === google.maps.GeocoderStatus.OK &&
                            'function' === typeof m.panTo &&
                            Array.isArray(results) &&
                            results.length
                        ) {
                            if (results[0].hasOwnProperty('geometry')) {
                                m.panTo(results[0].geometry.location);
                            }
                        } else {
                            console.error(status);
                        }
                    });
                } else {
                    if ('function' === typeof m.panTo) {
                        m.panTo(loc);
                    }
                }
            }
            return this;
        },
        //#!#END
        //#!#START CLEAR
        /**
         * Method: Google Maps clear the specificed layer
         * @param {string} type Layer type
         * @public
         */
        clear: function (layer) {
            var self     = this,
                labels   = self._labels,
                dMarkers = self._directionsMarkers,
                i        = 0,
                j        = 0,
                obj      = {},
                key      = '',
                item     = {};

            try {
                if (undefined === layer) {
                    layer = {
                        'marker': [],
                        'label' : [],
                        'polyline': [],
                        'polygon' : [],
                        'circle'  : [],
                        'direction': [],
                        'kml': [],
                        'cluster': []
                    };
                }
                for (obj in layer) {
                    if (Array.isArray(layer[obj])) {
                        key = '_' + obj.toString().toLowerCase() + 's';
                        if (undefined !== self[key]) {
                            for (i = 0; i < self[key].length; i += 1) {
                                item = self[key][i];
                                if (0 === layer[obj].length ||
                                    (-1 !== layer[obj].indexOf(i)) ||
                                    (item.hasOwnProperty('id') && -1 !== layer[obj].indexOf(item.id))
                                ) {
                                    if ('function' === typeof item.clearMarkers) {
                                        item.clearMarkers();
                                    } else if ('function' === typeof item.set) {
                                        item.set('visible', false);
                                        item.set('directions', null);
                                    } else if ('function' === typeof item.setMap) {
                                        item.setMap(null);
                                    }
                                    // Clear label of Markers.
                                    if ('_markers' === key) {
                                        self._markers.splice(i, 1);
                                        if (undefined !== labels[i] && labels.hasOwnProperty('div')) {
                                            self._labels[i].div.remove();
                                        }
                                    }
                                    // Remove the direction icons.
                                    if ('_directions' === key) {
                                        self._directions.splice(i, 1);
                                        for (j = dMarkers.length - 1; j >= 0; j -= 1) {
                                            if ('function' === typeof dMarkers[j].setMap) {
                                                self._directionsMarkers[j].setMap(null);
                                                self._directionsMarkers.splice(j, 1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (ignore) {
            } finally {
                return $(this.container);
            }
        },
        //#!#END
        //#!#START MODIFY
        /**
         * Method:  Google Maps dynamic add layers
         * @param {Object} options Refernce by tinyMap options
         * @public
         */
        modify: function (options) {
            var self  = this,
                func  = [],
                label = [
                    ['kml', 'kml'],
                    ['marker', 'markers'],
                    ['direction', 'direction'],
                    ['polyline', 'drawPolyline'],
                    ['polygon', 'drawPolygon'],
                    ['circle', 'drawCircle'],
                    ['streetView', 'streetView'],
                    ['markerFitBounds', 'markerFitBounds']
                ],
                i = 0,
                m = self.map;

            google.maps.event.trigger(m, 'resize');

            if (undefined !== options) {
                for (i = label.length - 1; i >= 0; i -= 1) {
                    if (options.hasOwnProperty(label[i][0])) {
                        func.push(label[i][1]);
                    }
                }
                if (null !== m) {
                    if (func.length) {
                        for (i = func.length - 1; i >= 0; i -= 1) {
                            if ('function' === typeof self[func[i]]) {
                                if ('streetView' === func[i]) {
                                    options.streetViewObj = options.streetView;
                                    delete options.streetView;
                                }
                                self[func[i]](m, options, 'modify');
                            }
                        }
                    } else {
                        m.setOptions(options);
                    }
                    if (options.hasOwnProperty('event')) {
                        self.bindEvents(m, options.event);
                    }
                }
            }
            return $(this.container);
        },
        //#!#END
        //#!#START DESTROY
        destroy: function () {
            var obj = $(this.container);
            if (obj.length) {
                $.removeData(this, 'tinyMap');
            }
            return obj.empty();
        },
        //#!#END
        //#!#START GETKML
        getKML: function (opt) {
            var m = $(this.container),
                md = m.data('tinyMap'),
                // Options
                opts = $.extend({}, {
                    'marker'   : true,
                    'polyline' : true,
                    'direction': true,
                    'download' : false
                }, opt),
                // MIME TYPE of KML
                mime = 'data:application/vnd.google-earth.kml+xml;charset=utf-8;base64,',
                // KML template
                templates = {
                    'xml': [
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<kml xmlns="http://earth.google.com/kml/2.2">',
                        '<Document>',
                        '<name><![CDATA[]]></name>',
                        '<description><![CDATA[]]></description>',
                        '<Style id="style1">',
                        '<IconStyle>',
                        '<Icon>',
                        '<href>//maps.google.com/mapfiles/kml/paddle/grn-circle_maps.png</href>',
                        '</Icon>',
                        '</IconStyle>',
                        '</Style>',
                        '#PLACEMARKS#',
                        '</Document>',
                        '</kml>'
                    ],
                    'placemark': [
                        '<Placemark>',
                        '<name><![CDATA[]]></name>',
                        '<Snippet></Snippet>',
                        '<description><![CDATA[]]></description>',
                        '<styleUrl>#style1</styleUrl>',
                        '<ExtendedData>',
                        '</ExtendedData>',
                        '#DATA#',
                        '</Placemark>'
                    ],
                    'linestring': '<LineString><tessellate>1</tessellate><coordinates>#LATLNG#</coordinates></LineString>',
                    'point': '<Point><coordinates>#LATLNG#,0.000000</coordinates></Point>'
                },
                markers      = [],
                polylines    = [],
                polygons     = [], // keep
                circles      = [], // keep
                directions   = [],
                strMarker    = '',
                strPolyline  = '',
                strDirection = '',
                output = '',
                latlng = '',
                legs   = [],
                path   = [],
                obj    = {},
                i = 0,
                j = -1,
                k = -1,
                v = -1;

            if (md) {
                // Build markers
                if (true === opts.marker) {
                    markers = md._markers;
                    for (i = length - 1; i >= 0; i -= 1) {
                        latlng = markers[i].position.lng() + ',' + markers[i].position.lat();
                        strMarker += templates.placemark.join('')
                                              .replace(
                                                  /#DATA#/gi,
                                                  templates.point.replace(/#LATLNG#/gi, latlng)
                                              );
                    }
                }
                // Build Polygons, Polylines and circles
                if (true === opts.polyline) {
                    polylines = md._polylines;
                    for (i = polylines.length - 1; i >= 0; i -= 1) {
                        obj = polylines[i].getPath().getArray();
                        latlng = '';
                        for (j = obj.length - 1; j >= 0; j -= 1) {
                            latlng += obj[j].lng() + ',' + obj[j].lat() + ',0.000000\n';
                        }
                        strPolyline += templates.placemark.join('')
                                                .replace(
                                                    /#DATA#/gi,
                                                    templates.linestring.replace(/#LATLNG#/gi, latlng)
                                                );

                    }
                }
                // Build Directions
                if (true === opts.direction) {
                    directions = md._directions;
                    for (i = directions.length - 1; i >= 0; i -= 1) {
                        if (directions[i].hasOwnProperty('directions') &&
                            directions[i].directions.hasOwnProperty('routes') &&
                            Array.isArray(directions[i].directions.routes) &&
                            0 < directions[i].directions.routes.length &&
                            directions[i].directions.routes[0].hasOwnProperty('legs') &&
                            Array.isArray(directions[i].directions.routes[0].legs)
                        ) {
                            legs = directions[i].directions.routes[0].legs;
                            for (j = legs.length - 1; j >= 0; j -= 1) {
                                if (Array.isArray(legs[j].steps)) {
                                    for (k = legs[j].steps.length - 1; k >= 0; k -= 1) {
                                        latlng = '';
                                        if (Array.isArray(legs[j].steps[k].path)) {
                                            for (v = legs[j].steps[k].path.length - 1; v >= 0; v -= 1) {
                                                path = legs[j].steps[k].path[v];
                                                if (undefined !== path && 'function' === typeof path.lat) {
                                                    latlng += path.lng() + ',' + path.lat() + ',0.000000\n';
                                                }
                                            }
                                        }
                                        strDirection += templates.placemark.join('')
                                                                 .replace(
                                                                     /#DATA#/gi,
                                                                     templates.linestring.replace(/#LATLNG#/gi, latlng)
                                                                 );
                                    }
                                }
                            }
                        }
                    }
                }
                // Output KML
                output = templates.xml.join('')
                                  .replace(
                                      /#PLACEMARKS#/gi,
                                      strMarker + strPolyline + strDirection
                                  );
                if (true === opts.download) {
                    window.open(mime + window.btoa(window.decodeURIComponent(window.encodeURIComponent(output))));
                } else {
                    return output;
                }
            }
        },
        //#!#END
        /**
         * tinyMap initialize
         */
        init: function Initialize () {

            var self     = this,
                script   = {},
                geocoder = {},
                param    = $.extend({}, tinyMapConfigure),
                api      = param.api.split('?')[0],
                msg      = '',
                o        = {};

            try {
                delete param.api;
                delete param.clusterer;
                param = $.param(param);
            } catch (ignore) {
            }
            
            // Asynchronous load the Google Maps API
            if (!apiLoaded && 'undefined' === typeof window.google) {
                script = document.createElement('script');
                script.setAttribute('src', [api, param].join('?'));
                (document.getElementsByTagName('head')[0] || document.documentElement).appendChild(script);
                apiLoaded = true;
                script    = null;
            }
            // Asynchronous load MarkerClusterer library
            if (!apiClusterLoaded && 'undefined' === typeof MarkerClusterer) {
                script = document.createElement('script');
                script.setAttribute('src', tinyMapConfigure.clusterer);
                (document.getElementsByTagName('head')[0] || document.documentElement).appendChild(script);
                apiClusterLoaded = true;
                script    = null;
            }

            // Make sure the API was loaded.
            if ('object' === typeof window.google) {
                self.bounds = new google.maps.LatLngBounds();
                //#!#START LABEL
                /**
                 * Label in Maps
                 * @param {Object} options Label options
                 * @constructor
                 */
                Label = function (options) {
                    var self = this,
                        css = options.hasOwnProperty('css') ? options.css.toString() : '';
                    self.setValues(options);
                    self.span = $('<span/>').css({
                        'position': 'relative',
                        'left': '-50%',
                        'top': '0',
                        'white-space': 'nowrap'
                    }).addClass(css);
                    self.div = $('<div/>').css({
                        'position': 'absolute',
                        'display': 'none'
                    });
                    self.span.appendTo(self.div);
                };
                /**
                 * Inherit from Google Maps OverlayView
                 * @this {Label}
                 */
                Label.prototype = new google.maps.OverlayView();
                /**
                 * binding the customize events to map
                 * @this {Label}
                 */
                Label.prototype.onAdd = function () {
                    var self = this;
                    self.div.appendTo($(self.getPanes().overlayLayer));
                    self.listeners = [
                        google.maps.event.addListener(self, 'visible_changed', self.onRemove)
                    ];
                };
                /**
                 * Label draw to map
                 * @this {Label}
                 */
                Label.prototype.draw = function () {
                    var projection = this.getProjection(),
                        position   = {};
                    try {
                        position = projection.fromLatLngToDivPixel(this.get('position'));
                        this.div.css({
                            'left'    : position.x + 'px',
                            'top'     : position.y + 'px',
                            'display' : 'block'
                        });
                        if (this.text) {
                            this.span.html(this.text.toString());
                        }
                    } catch (ignore) {
                        console.error(ignore);
                    }
                };
                /**
                 * Label remove from the map
                 * @this {Label}
                 */
                Label.prototype.onRemove = function () {
                    $(this.div).remove();
                };
                //#!#END
                // Parsing ControlOptions
                for (o in self.options) {
                    if (self.options.hasOwnProperty(o)) {
                        vo = self.options[o];
                        if (/ControlOptions/g.test(o) &&
                            vo.hasOwnProperty('position') &&
                            'string' === typeof vo.position
                        ) {
                            self.options[o].position = google.maps.ControlPosition[vo.position.toUpperCase()];
                        }
                    }
                }

                // Merge options
                self.googleMapOptions = self.options;

                // Process streetView conflict
                if (self.options.hasOwnProperty('streetView')) {
                    self.googleMapOptions.streetViewObj = self.options.streetView;
                    delete self.googleMapOptions.streetView;
                }

                // Parsing Center location
                self.googleMapOptions.center = parseLatLng(self.options.center, true);

                //#!#START STYLES
                // Map styles apply
                if (self.options.hasOwnProperty('styles')) {
                    if ('string' === typeof self.options.styles &&
                        styles.hasOwnProperty(self.options.styles)
                    ) {
                        self.googleMapOptions.styles = styles[self.options.styles];
                    } else if (Array.isArray(self.options.styles)) {
                        self.googleMapOptions.styles = self.options.styles;
                    }
                }
                //#!#END
                if ('string' === typeof self.options.center) {
                    geocoder = new google.maps.Geocoder();
                    geocoder.geocode({'address': self.options.center}, function (results, status) {
                        try {
                            if (status === google.maps.GeocoderStatus.OVER_QUERY_LIMIT) {
                                window.setTimeout(function () {
                                    self.init();
                                }, self.interval);
                            } else if (status === google.maps.GeocoderStatus.OK && Array.isArray(results)) {
                                if (0 < results.length && results[0].hasOwnProperty('geometry')) {
                                    self.googleMapOptions.center = results[0].geometry.location;
                                    self.map = new google.maps.Map(self.container, self.googleMapOptions);
                                    google.maps.event.addListenerOnce(self.map, 'idle', function () {
                                        self.overlay();
                                        google.maps.event.trigger(self.map, 'resize');
                                    });
                                    self.bindEvents(self.map, self.options.event);
                                }
                            } else {
                                msg = (self.options.notFound || status).toString();
                                self.container.innerHTML($('<div/>').text(msg).html());
                                console.error('Geocoder Error Code: ' + status);
                            }
                        } catch (ignore) {
                            console.error(ignore);
                        }
                    });
                } else {
                    self.map = new google.maps.Map(self.container, self.googleMapOptions);
                    google.maps.event.addListenerOnce(self.map, 'idle', function () {
                        self.overlay();
                        google.maps.event.trigger(self.map, 'resize');
                    });
                    self.bindEvents(self.map, self.options.event);
                }
            }
        }
    };
    /**
     * jQuery tinyMap API configure
     * @param {Object} options Plugin configure
     * @public
     */
    $.fn.tinyMapConfigure = function (options) {
        tinyMapConfigure = $.extend(tinyMapConfigure, options);
    };
    /**
     * Calculate distances
     * @param {Object} options Query params
     * @param {Function} callback Function for callback
     */
    $.fn.tinyMapDistance = function (options, callback) {
        var def = {
                'key': tinyMapConfigure.hasOwnProperty('key') ? tinyMapConfigure.key : '',
                'origins': [],
                'destinations': [],
                'language': 'zh-TW'
            },
            i = 0,
            opt = $.extend({}, def, options);

        if (Array.isArray(opt.origins)) {
            opt.origins = opt.origins.join('|');
        }
        if (Array.isArray(opt.destinations)) {
            opt.destinations = opt.destinations.join('|');
        }

        $.getJSON(
            '//maps.googleapis.com/maps/api/distancematrix/json',
            opt,
            function (data) {
                if (data.status === 'OK') {
                    //console.dir(data);
                    callback(data);
                }
            });
    };
    /**
     * Quick query latlng/address
     * @param {Object} options Query params
     * @param {Function} callback Function for callback
     */
    $.fn.tinyMapQuery = function (options, callback) {
        var def = {
                'key': tinyMapConfigure.hasOwnProperty('key') ? tinyMapConfigure.key : '',
                'language': 'zh-TW'
            },
            opt = $.extend({}, def, options),
            result = null;

        $.getJSON(
            '//maps.googleapis.com/maps/api/geocode/json',
            opt,
            function (data) {
                if (data.status === 'OK') {
                    if (data.results && undefined !== data.results[0]) {
                        if (opt.hasOwnProperty('latlng')) {
                            result = data.results[0].formatted_address;
                        } else if (opt.hasOwnProperty('address')) {
                            result = [
                                data.results[0].geometry.location.lat,
                                data.results[0].geometry.location.lng
                            ].join(',');
                        }
                        callback(result);
                    }
                }
            });
    };
    /**
     * jQuery tinyMap instance
     * @param {Object} options Plugin settings
     * @public
     */
    $.fn.tinyMap = function (options) {
        var instance = {},
            result = [],
            args = arguments,
            id   = 'tinyMap';
        if ('string' === typeof options) {
            this.each(function () {
                instance = $.data(this, id);
                if (instance instanceof TinyMap && 'function' === typeof instance[options]) {
                    result = instance[options].apply(instance, Array.prototype.slice.call(args, 1));
                }
            });
            return undefined !== result ? result : this;
        } else {
            return this.each(function () {
                if (!$.data(this, id)) {
                    $.data(this, id, new TinyMap(this, options));
                }
            });
        }
    };
})(window.jQuery || {}, window, document);
//#EOF
;
/*!
 *
 * jQuery collageCaption Plugin v0.1.1
 * extra for collagePlus plugin
 * https://github.com/ed-lea/jquery-collagePlus
 *
 * Copyright 2012, Ed Lea twitter.com/ed_lea
 *
 * built for http://qiip.me
 *
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/GPL-2.0
 *
 */

;(function(e){e.fn.collageCaption=function(t){var n={images:e(this).children(),background:"black",opacity:"0.5",speed:100,cssClass:"Caption"};var r=e.extend({},n,t);return this.each(function(){var t=0,n=[];r.images.each(function(t){var n=e(this);if(typeof n.data("caption")=="undefined"){return}var i='<div class="'+r.cssClass+'" style="position:relative;"><div class="Caption_Background" style="background-color:'+r.background+";opacity:"+r.opacity+';position:relative;top:0;"></div><div class="Caption_Content" style="position:relative;">'+n.data("caption")+"</div></div>";n.append(i);var s=n.find("."+r.cssClass),o=n.find(".Caption_Background"),u=n.find(".Caption_Content");var a=s.height();o.height(a);u.css("top","-"+a+"px");n.bind({mouseenter:function(e){s.animate({top:-1*a},{duration:r.speed,queue:false})},mouseleave:function(e){s.animate({top:0},{duration:r.speed,queue:false})}})});return this})}})(jQuery);
/*!
 *
 * jQuery collagePlus Plugin v0.3.3
 * https://github.com/ed-lea/jquery-collagePlus
 *
 * Copyright 2012, Ed Lea twitter.com/ed_lea
 *
 * built for http://qiip.me
 *
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.opensource.org/licenses/GPL-2.0
 *
 */

;(function(e){e.fn.collagePlus=function(t){function n(t,n,i,s){var o=i.padding*(t.length-1)+t.length*t[0][3],u=i.albumWidth-o,a=u/(n-o),f=o,l=n<i.albumWidth?true:false;for(var c=0;c<t.length;c++){var h=e(t[c][0]),p=Math.floor(t[c][1]*a),d=Math.floor(t[c][2]*a),v=!!(c<t.length-1);if(i.allowPartialLastRow===true&&l===true){p=t[c][1];d=t[c][2]}f+=p;if(!v&&f<i.albumWidth){if(i.allowPartialLastRow===true&&l===true){p=p}else{p=p+(i.albumWidth-f)}}p--;var m=h.is("img")?h:h.find("img");m.width(p);if(!h.is("img")){h.width(p+t[c][3])}m.height(d);if(!h.is("img")){h.height(d+t[c][4])}r(h,v,i);m.one("load",function(e){return function(){if(i.effect=="default"){e.animate({opacity:"1"},{duration:i.fadeSpeed})}else{if(i.direction=="vertical"){var t=s<=10?s:10}else{var t=c<=9?c+1:10}e.removeClass(function(e,t){return(t.match(/\beffect-\S+/g)||[]).join(" ")});e.addClass(i.effect);e.addClass("effect-duration-"+t)}}}(h)).each(function(){if(this.complete)e(this).trigger("load")})}}function r(e,t,n){var r={"margin-bottom":n.padding+"px","margin-right":t?n.padding+"px":"0px",display:n.display,"vertical-align":"bottom",overflow:"hidden"};return e.css(r)}function i(t){$img=e(t);var n=new Array;n["w"]=parseFloat($img.css("border-left-width"))+parseFloat($img.css("border-right-width"));n["h"]=parseFloat($img.css("border-top-width"))+parseFloat($img.css("border-bottom-width"));return n}return this.each(function(){var r=0,s=[],o=1,u=e(this);e.fn.collagePlus.defaults.albumWidth=u.width();e.fn.collagePlus.defaults.padding=parseFloat(u.css("padding-left"));e.fn.collagePlus.defaults.images=u.children();var a=e.extend({},e.fn.collagePlus.defaults,t);a.images.each(function(t){var u=e(this),f=u.is("img")?u:e(this).find("img");var l=typeof f.data("width")!="undefined"?f.data("width"):f.width(),c=typeof f.data("height")!="undefined"?f.data("height"):f.height();var h=i(f);f.data("width",l);f.data("height",c);var p=Math.ceil(l/c*a.targetHeight),d=Math.ceil(a.targetHeight);s.push([this,p,d,h["w"],h["h"]]);r+=p+h["w"]+a.padding;if(r>a.albumWidth&&s.length!=0){n(s,r-a.padding,a,o);delete r;delete s;r=0;s=[];o+=1}if(a.images.length-1==t&&s.length!=0){n(s,r,a,o);delete r;delete s;r=0;s=[];o+=1}})})};e.fn.collagePlus.defaults={targetHeight:400,fadeSpeed:"fast",display:"inline-block",effect:"default",direction:"vertical",allowPartialLastRow:false}})(jQuery);
(function(a){a.fn.removeWhitespace=function(){this.contents().filter(function(){return this.nodeType==3&&!/\S/.test(this.nodeValue)}).remove();return this}})(jQuery)
;
/*!
	Colorbox 1.6.1
	license: MIT
	http://www.jacklmoore.com/colorbox
*/

(function(t,e,i){function n(i,n,o){var r=e.createElement(i);return n&&(r.id=Z+n),o&&(r.style.cssText=o),t(r)}function o(){return i.innerHeight?i.innerHeight:t(i).height()}function r(e,i){i!==Object(i)&&(i={}),this.cache={},this.el=e,this.value=function(e){var n;return void 0===this.cache[e]&&(n=t(this.el).attr("data-cbox-"+e),void 0!==n?this.cache[e]=n:void 0!==i[e]?this.cache[e]=i[e]:void 0!==X[e]&&(this.cache[e]=X[e])),this.cache[e]},this.get=function(e){var i=this.value(e);return t.isFunction(i)?i.call(this.el,this):i}}function h(t){var e=W.length,i=(A+t)%e;return 0>i?e+i:i}function a(t,e){return Math.round((/%/.test(t)?("x"===e?E.width():o())/100:1)*parseInt(t,10))}function s(t,e){return t.get("photo")||t.get("photoRegex").test(e)}function l(t,e){return t.get("retinaUrl")&&i.devicePixelRatio>1?e.replace(t.get("photoRegex"),t.get("retinaSuffix")):e}function d(t){"contains"in y[0]&&!y[0].contains(t.target)&&t.target!==v[0]&&(t.stopPropagation(),y.focus())}function c(t){c.str!==t&&(y.add(v).removeClass(c.str).addClass(t),c.str=t)}function g(e){A=0,e&&e!==!1&&"nofollow"!==e?(W=t("."+te).filter(function(){var i=t.data(this,Y),n=new r(this,i);return n.get("rel")===e}),A=W.index(_.el),-1===A&&(W=W.add(_.el),A=W.length-1)):W=t(_.el)}function u(i){t(e).trigger(i),ae.triggerHandler(i)}function f(i){var o;if(!G){if(o=t(i).data(Y),_=new r(i,o),g(_.get("rel")),!$){$=q=!0,c(_.get("className")),y.css({visibility:"hidden",display:"block",opacity:""}),I=n(se,"LoadedContent","width:0; height:0; overflow:hidden; visibility:hidden"),b.css({width:"",height:""}).append(I),j=T.height()+k.height()+b.outerHeight(!0)-b.height(),D=C.width()+H.width()+b.outerWidth(!0)-b.width(),N=I.outerHeight(!0),z=I.outerWidth(!0);var h=a(_.get("initialWidth"),"x"),s=a(_.get("initialHeight"),"y"),l=_.get("maxWidth"),f=_.get("maxHeight");_.w=(l!==!1?Math.min(h,a(l,"x")):h)-z-D,_.h=(f!==!1?Math.min(s,a(f,"y")):s)-N-j,I.css({width:"",height:_.h}),J.position(),u(ee),_.get("onOpen"),O.add(S).hide(),y.focus(),_.get("trapFocus")&&e.addEventListener&&(e.addEventListener("focus",d,!0),ae.one(re,function(){e.removeEventListener("focus",d,!0)})),_.get("returnFocus")&&ae.one(re,function(){t(_.el).focus()})}var p=parseFloat(_.get("opacity"));v.css({opacity:p===p?p:"",cursor:_.get("overlayClose")?"pointer":"",visibility:"visible"}).show(),_.get("closeButton")?B.html(_.get("close")).appendTo(b):B.appendTo("<div/>"),w()}}function p(){y||(V=!1,E=t(i),y=n(se).attr({id:Y,"class":t.support.opacity===!1?Z+"IE":"",role:"dialog",tabindex:"-1"}).hide(),v=n(se,"Overlay").hide(),M=t([n(se,"LoadingOverlay")[0],n(se,"LoadingGraphic")[0]]),x=n(se,"Wrapper"),b=n(se,"Content").append(S=n(se,"Title"),F=n(se,"Current"),P=t('<button type="button"/>').attr({id:Z+"Previous"}),K=t('<button type="button"/>').attr({id:Z+"Next"}),R=n("button","Slideshow"),M),B=t('<button type="button"/>').attr({id:Z+"Close"}),x.append(n(se).append(n(se,"TopLeft"),T=n(se,"TopCenter"),n(se,"TopRight")),n(se,!1,"clear:left").append(C=n(se,"MiddleLeft"),b,H=n(se,"MiddleRight")),n(se,!1,"clear:left").append(n(se,"BottomLeft"),k=n(se,"BottomCenter"),n(se,"BottomRight"))).find("div div").css({"float":"left"}),L=n(se,!1,"position:absolute; width:9999px; visibility:hidden; display:none; max-width:none;"),O=K.add(P).add(F).add(R)),e.body&&!y.parent().length&&t(e.body).append(v,y.append(x,L))}function m(){function i(t){t.which>1||t.shiftKey||t.altKey||t.metaKey||t.ctrlKey||(t.preventDefault(),f(this))}return y?(V||(V=!0,K.click(function(){J.next()}),P.click(function(){J.prev()}),B.click(function(){J.close()}),v.click(function(){_.get("overlayClose")&&J.close()}),t(e).bind("keydown."+Z,function(t){var e=t.keyCode;$&&_.get("escKey")&&27===e&&(t.preventDefault(),J.close()),$&&_.get("arrowKey")&&W[1]&&!t.altKey&&(37===e?(t.preventDefault(),P.click()):39===e&&(t.preventDefault(),K.click()))}),t.isFunction(t.fn.on)?t(e).on("click."+Z,"."+te,i):t("."+te).live("click."+Z,i)),!0):!1}function w(){var e,o,r,h=J.prep,d=++le;if(q=!0,U=!1,u(he),u(ie),_.get("onLoad"),_.h=_.get("height")?a(_.get("height"),"y")-N-j:_.get("innerHeight")&&a(_.get("innerHeight"),"y"),_.w=_.get("width")?a(_.get("width"),"x")-z-D:_.get("innerWidth")&&a(_.get("innerWidth"),"x"),_.mw=_.w,_.mh=_.h,_.get("maxWidth")&&(_.mw=a(_.get("maxWidth"),"x")-z-D,_.mw=_.w&&_.w<_.mw?_.w:_.mw),_.get("maxHeight")&&(_.mh=a(_.get("maxHeight"),"y")-N-j,_.mh=_.h&&_.h<_.mh?_.h:_.mh),e=_.get("href"),Q=setTimeout(function(){M.show()},100),_.get("inline")){var c=t(e);r=t("<div>").hide().insertBefore(c),ae.one(he,function(){r.replaceWith(c)}),h(c)}else _.get("iframe")?h(" "):_.get("html")?h(_.get("html")):s(_,e)?(e=l(_,e),U=_.get("createImg"),t(U).addClass(Z+"Photo").bind("error."+Z,function(){h(n(se,"Error").html(_.get("imgError")))}).one("load",function(){d===le&&setTimeout(function(){var e;_.get("retinaImage")&&i.devicePixelRatio>1&&(U.height=U.height/i.devicePixelRatio,U.width=U.width/i.devicePixelRatio),_.get("scalePhotos")&&(o=function(){U.height-=U.height*e,U.width-=U.width*e},_.mw&&U.width>_.mw&&(e=(U.width-_.mw)/U.width,o()),_.mh&&U.height>_.mh&&(e=(U.height-_.mh)/U.height,o())),_.h&&(U.style.marginTop=Math.max(_.mh-U.height,0)/2+"px"),W[1]&&(_.get("loop")||W[A+1])&&(U.style.cursor="pointer",t(U).bind("click."+Z,function(){J.next()})),U.style.width=U.width+"px",U.style.height=U.height+"px",h(U)},1)}),U.src=e):e&&L.load(e,_.get("data"),function(e,i){d===le&&h("error"===i?n(se,"Error").html(_.get("xhrError")):t(this).contents())})}var v,y,x,b,T,C,H,k,W,E,I,L,M,S,F,R,K,P,B,O,_,j,D,N,z,A,U,$,q,G,Q,J,V,X={html:!1,photo:!1,iframe:!1,inline:!1,transition:"elastic",speed:300,fadeOut:300,width:!1,initialWidth:"600",innerWidth:!1,maxWidth:!1,height:!1,initialHeight:"450",innerHeight:!1,maxHeight:!1,scalePhotos:!0,scrolling:!0,opacity:.9,preloading:!0,className:!1,overlayClose:!0,escKey:!0,arrowKey:!0,top:!1,bottom:!1,left:!1,right:!1,fixed:!1,data:void 0,closeButton:!0,fastIframe:!0,open:!1,reposition:!0,loop:!0,slideshow:!1,slideshowAuto:!0,slideshowSpeed:2500,slideshowStart:"start slideshow",slideshowStop:"stop slideshow",photoRegex:/\.(gif|png|jp(e|g|eg)|bmp|ico|webp|jxr|svg)((#|\?).*)?$/i,retinaImage:!1,retinaUrl:!1,retinaSuffix:"@2x.$1",current:"image {current} of {total}",previous:"previous",next:"next",close:"close",xhrError:"This content failed to load.",imgError:"This image failed to load.",returnFocus:!0,trapFocus:!0,onOpen:!1,onLoad:!1,onComplete:!1,onCleanup:!1,onClosed:!1,rel:function(){return this.rel},href:function(){return t(this).attr("href")},title:function(){return this.title},createImg:function(){var e=new Image,i=t(this).data("cbox-img-attrs");return"object"==typeof i&&t.each(i,function(t,i){e[t]=i}),e},createIframe:function(){var i=e.createElement("iframe"),n=t(this).data("cbox-iframe-attrs");return"object"==typeof n&&t.each(n,function(t,e){i[t]=e}),"frameBorder"in i&&(i.frameBorder=0),"allowTransparency"in i&&(i.allowTransparency="true"),i.name=(new Date).getTime(),i.allowFullScreen=!0,i}},Y="colorbox",Z="cbox",te=Z+"Element",ee=Z+"_open",ie=Z+"_load",ne=Z+"_complete",oe=Z+"_cleanup",re=Z+"_closed",he=Z+"_purge",ae=t("<a/>"),se="div",le=0,de={},ce=function(){function t(){clearTimeout(h)}function e(){(_.get("loop")||W[A+1])&&(t(),h=setTimeout(J.next,_.get("slideshowSpeed")))}function i(){R.html(_.get("slideshowStop")).unbind(s).one(s,n),ae.bind(ne,e).bind(ie,t),y.removeClass(a+"off").addClass(a+"on")}function n(){t(),ae.unbind(ne,e).unbind(ie,t),R.html(_.get("slideshowStart")).unbind(s).one(s,function(){J.next(),i()}),y.removeClass(a+"on").addClass(a+"off")}function o(){r=!1,R.hide(),t(),ae.unbind(ne,e).unbind(ie,t),y.removeClass(a+"off "+a+"on")}var r,h,a=Z+"Slideshow_",s="click."+Z;return function(){r?_.get("slideshow")||(ae.unbind(oe,o),o()):_.get("slideshow")&&W[1]&&(r=!0,ae.one(oe,o),_.get("slideshowAuto")?i():n(),R.show())}}();t[Y]||(t(p),J=t.fn[Y]=t[Y]=function(e,i){var n,o=this;return e=e||{},t.isFunction(o)&&(o=t("<a/>"),e.open=!0),o[0]?(p(),m()&&(i&&(e.onComplete=i),o.each(function(){var i=t.data(this,Y)||{};t.data(this,Y,t.extend(i,e))}).addClass(te),n=new r(o[0],e),n.get("open")&&f(o[0])),o):o},J.position=function(e,i){function n(){T[0].style.width=k[0].style.width=b[0].style.width=parseInt(y[0].style.width,10)-D+"px",b[0].style.height=C[0].style.height=H[0].style.height=parseInt(y[0].style.height,10)-j+"px"}var r,h,s,l=0,d=0,c=y.offset();if(E.unbind("resize."+Z),y.css({top:-9e4,left:-9e4}),h=E.scrollTop(),s=E.scrollLeft(),_.get("fixed")?(c.top-=h,c.left-=s,y.css({position:"fixed"})):(l=h,d=s,y.css({position:"absolute"})),d+=_.get("right")!==!1?Math.max(E.width()-_.w-z-D-a(_.get("right"),"x"),0):_.get("left")!==!1?a(_.get("left"),"x"):Math.round(Math.max(E.width()-_.w-z-D,0)/2),l+=_.get("bottom")!==!1?Math.max(o()-_.h-N-j-a(_.get("bottom"),"y"),0):_.get("top")!==!1?a(_.get("top"),"y"):Math.round(Math.max(o()-_.h-N-j,0)/2),y.css({top:c.top,left:c.left,visibility:"visible"}),x[0].style.width=x[0].style.height="9999px",r={width:_.w+z+D,height:_.h+N+j,top:l,left:d},e){var g=0;t.each(r,function(t){return r[t]!==de[t]?(g=e,void 0):void 0}),e=g}de=r,e||y.css(r),y.dequeue().animate(r,{duration:e||0,complete:function(){n(),q=!1,x[0].style.width=_.w+z+D+"px",x[0].style.height=_.h+N+j+"px",_.get("reposition")&&setTimeout(function(){E.bind("resize."+Z,J.position)},1),t.isFunction(i)&&i()},step:n})},J.resize=function(t){var e;$&&(t=t||{},t.width&&(_.w=a(t.width,"x")-z-D),t.innerWidth&&(_.w=a(t.innerWidth,"x")),I.css({width:_.w}),t.height&&(_.h=a(t.height,"y")-N-j),t.innerHeight&&(_.h=a(t.innerHeight,"y")),t.innerHeight||t.height||(e=I.scrollTop(),I.css({height:"auto"}),_.h=I.height()),I.css({height:_.h}),e&&I.scrollTop(e),J.position("none"===_.get("transition")?0:_.get("speed")))},J.prep=function(i){function o(){return _.w=_.w||I.width(),_.w=_.mw&&_.mw<_.w?_.mw:_.w,_.w}function a(){return _.h=_.h||I.height(),_.h=_.mh&&_.mh<_.h?_.mh:_.h,_.h}if($){var d,g="none"===_.get("transition")?0:_.get("speed");I.remove(),I=n(se,"LoadedContent").append(i),I.hide().appendTo(L.show()).css({width:o(),overflow:_.get("scrolling")?"auto":"hidden"}).css({height:a()}).prependTo(b),L.hide(),t(U).css({"float":"none"}),c(_.get("className")),d=function(){function i(){t.support.opacity===!1&&y[0].style.removeAttribute("filter")}var n,o,a=W.length;$&&(o=function(){clearTimeout(Q),M.hide(),u(ne),_.get("onComplete")},S.html(_.get("title")).show(),I.show(),a>1?("string"==typeof _.get("current")&&F.html(_.get("current").replace("{current}",A+1).replace("{total}",a)).show(),K[_.get("loop")||a-1>A?"show":"hide"]().html(_.get("next")),P[_.get("loop")||A?"show":"hide"]().html(_.get("previous")),ce(),_.get("preloading")&&t.each([h(-1),h(1)],function(){var i,n=W[this],o=new r(n,t.data(n,Y)),h=o.get("href");h&&s(o,h)&&(h=l(o,h),i=e.createElement("img"),i.src=h)})):O.hide(),_.get("iframe")?(n=_.get("createIframe"),_.get("scrolling")||(n.scrolling="no"),t(n).attr({src:_.get("href"),"class":Z+"Iframe"}).one("load",o).appendTo(I),ae.one(he,function(){n.src="//about:blank"}),_.get("fastIframe")&&t(n).trigger("load")):o(),"fade"===_.get("transition")?y.fadeTo(g,1,i):i())},"fade"===_.get("transition")?y.fadeTo(g,0,function(){J.position(0,d)}):J.position(g,d)}},J.next=function(){!q&&W[1]&&(_.get("loop")||W[A+1])&&(A=h(1),f(W[A]))},J.prev=function(){!q&&W[1]&&(_.get("loop")||A)&&(A=h(-1),f(W[A]))},J.close=function(){$&&!G&&(G=!0,$=!1,u(oe),_.get("onCleanup"),E.unbind("."+Z),v.fadeTo(_.get("fadeOut")||0,0),y.stop().fadeTo(_.get("fadeOut")||0,0,function(){y.hide(),v.hide(),u(he),I.remove(),setTimeout(function(){G=!1,u(re),_.get("onClosed")},1)}))},J.remove=function(){y&&(y.stop(),t[Y].close(),y.stop(!1,!0).remove(),v.remove(),G=!1,y=null,t("."+te).removeData(Y).removeClass(te),t(e).unbind("click."+Z).unbind("keydown."+Z))},J.element=function(){return t(_.el)},J.settings=X)})(jQuery,document,window);






// jQuery to collapse the navbar on scroll
		$(window).scroll(function() {
			if ($(".navbar").offset().top > 50) {
				$(".navbar-fixed-top").addClass("top-nav-collapse");
				//console.log("YOSH");
			}
			else {
				$(".navbar-fixed-top").removeClass("top-nav-collapse");
			}
		});
		
		
		// for responsive design
		var ReadyandResize = function(){
			var win = $(window);
            var windowHeight = win.outerHeight();
            var navHeight = $("#navbar").outerHeight();
			var menuHeight = $('div.menu').height();
			
			if (win.width() < 768) { // small screen case
                // Set supersliders' container
				var calculatedHeight = windowHeight - navHeight;
                var heightFill = $('.height-fill');
                $(heightFill).height(calculatedHeight);
                $(heightFill).width($('body').outerWidth());
                //console.log("Blocked NavBar Case");
                
				// Set #ul_about rule 
				if($('#ul_about').hasClass("nav-stacked")){
                    $('#ul_about').removeClass("nav-stacked");
					//console.log("Oh~No!!");
                }
                if(win.width() < 600){ 
                    $('#ul_about').css('display','block');
                }
                else{
                    $('#ul_about').css('display','inline-block');
                }
				
				// padding for navbar
                $('body').css('padding-top',navHeight);
            }
            else { // large screen case
                // Set supersliders' container
				var heightFill = $('.height-fill');
                $(heightFill).height(windowHeight);
                $(heightFill).width($('body').outerWidth());
                //console.log("Transparent NavBar Case");
				
				// Set #ul_about rule
                if(!$('#ul_about').hasClass("nav-stacked")){
                    $('#ul_about').addClass("nav-stacked");
					//console.log("Hey!!");
                }
				
				$('#ul_about').css('display','block'); 
				
				// no padding for navbar
                $('body').css('padding-top',0);
            }
			
			// for title showup
			$('#title_container').css('padding-top',$('.height-fill').height()*0.85);

            // superslides
            var $slides = $('#slides');
            
            // mobile devices swipe shift
            Hammer($slides[0]).on("swipeleft", function(e) {
                $slides.data('superslides').animate('next');
            });

            Hammer($slides[0]).on("swiperight", function(e) {
                $slides.data('superslides').animate('prev');
            });
            
            // superslides activate
            $('#slides').superslides({
                inherit_height_from: '.height-fill',
                inherit_width_from: '.height-fill',
				hashchange: false,
                play: 7000, // 7s per slide
				animation: 'fade'
            });
            
            // superslides play setting
            var hoverTimer = 0;
            $('#slides').on('mouseenter', function() {
                $(this).superslides('stop');
                clearTimeout(hoverTimer);
                //console.log(hoverTimer);
            });
            
            $('#slides').on('mouseleave', function() {
                hoverTimer = setTimeout(function(){
                    $slides.superslides('start');
                    //console.log(hoverTimer);
                }, 7000);
            });
			
			// set up banner size (as sliders')
            var containerHeight = $('#slides').height();
            var containerWidth = $('#slides').width();
            $('#poster').outerHeight(containerHeight);
            $('#poster').outerWidth(containerWidth);
			
            
			$('a.page-scroll').bind('click', function(event) {
                var $anchor = $(this);
                $('html, body').stop().animate({
                    scrollTop: $($anchor.attr('href')).offset().top - (menuHeight - 1)
                }, 1500, 'easeInOutExpo');
                event.preventDefault();
            });
			
            
			// scrollspy修改offset只能動到click事件,scroll到各個section以切換active li事件部分得自己寫...
            $(window).scroll(function() {
                
                var cur_pos = $(window).scrollTop();
                var sections = $('section');
                var navbar = $('#navbar')

                sections.each(function(){
                    
                    //console.log($(this).attr('id').toString());
                    var top = $(this).offset().top - menuHeight;
                    var bottom = top + $(this).outerHeight();

                    if(cur_pos >= top && cur_pos <= bottom){
                        navbar.find('li').removeClass('active');
                        navbar.find('a[href="#'+$(this).attr('id')+'"]').parent('li').addClass('active');
                    }
                });
				
                if(cur_pos < $('#news').offset().top - menuHeight){
                    var nav_lis = navbar.find('li');
                    nav_lis.each(function(){
                        if($(this).hasClass('active')){
                            $(this).removeClass('active');
                        } 
                    });
                }
            });
			
			// top 5 portrait size
            $('img.top5_portrait').height(windowHeight*0.10);

            // for 16 : 9 map size :)
            $('#panel_map').height($('#practice').width() * 0.50625);
            $('#panel_map').width($('#practice').width() * 0.9);

            $('.map_description').css('padding-left',$('#practice').width()*0.1);
            $('.map_description').css('max-width',$('#practice').width()*0.9);
			
            // for height coherency of "About" section
			var aboutHeight = Math.max($('#practice').height(),$('#infoSource').height(),$('#forFresh').height(),$('#reference').height());
			$('#practice').css('min-height',aboutHeight);
			$('#infoSource').css('min-height',aboutHeight);
			$('#forFresh').css('min-height',aboutHeight);
			$('#reference').css('min-height',aboutHeight);
			
		};
		
		$(document).ready(ReadyandResize);
		$(window).resize(ReadyandResize);

        $(window).on('resize', function(){

            // load的時候地圖也會跑掉，所以要resize一次
            var m = $('#map').data('tinyMap');
            // 1.觸發 map resize 事件
            google.maps.event.trigger(m.map, 'resize');
            // 2.移動地圖中心
            m.map.panTo(new google.maps.LatLng('25.017344', '121.539746'));
        });
