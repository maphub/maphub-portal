/**
 * @name ExtDraggableObject
 * @version 1.0
 * @author Gabriel Schneider
 * @copyright (c) 2009 Gabriel Schneider
 * @fileoverview This sets up a given DOM element to be draggable
 *     around the page.
 */
/*
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License. 
 */
/**
 * Sets up a DOM element to be draggable. The options available
 *     within {@link ExtDraggableObjectOptions} are: top, left, container,
 *     draggingCursor, draggableCursor, intervalX, intervalY,
 *     toleranceX, toleranceY, restrictX, and restrictY.
 * @param {HTMLElement} src The element to make draggable
 * @param {ExtDraggableObjectOptions} [opts] options
 * @constructor
 */
function ExtDraggableObject(e,t){function N(t){t?e.style.cursor=s:e.style.cursor=o}function C(t,n,r){var s,o;m=Math.round(t),v=Math.round(n),i.intervalX>1&&(s=Math.round(m%i.intervalX),m=s<S?m-s:m+(i.intervalX-s)),i.intervalY>1&&(o=Math.round(v%i.intervalY),v=o<x?v-o:v+(i.intervalY-o)),i.container&&i.container.offsetWidth&&(m=Math.max(0,Math.min(m,i.container.offsetWidth-e.offsetWidth)),v=Math.max(0,Math.min(v,i.container.offsetHeight-e.offsetHeight))),typeof f=="number"&&(m-f>i.toleranceX||f-(m+e.offsetWidth)>i.toleranceX||v-l>i.toleranceY||l-(v+e.offsetHeight)>i.toleranceY)&&(m=w,v=E),!i.restrictX&&!r&&(e.style.left=m+"px"),!i.restrictY&&!r&&(e.style.top=v+"px")}function k(e){var t=e||event;f=h+((t.pageX||t.clientX+document.body.scrollLeft+document.documentElement.scrollLeft)-p),l=c+((t.pageY||t.clientY+document.body.scrollTop+document.documentElement.scrollTop)-d),h=f,c=l,p=t.pageX||t.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,d=t.pageY||t.clientY+document.body.scrollTop+document.documentElement.scrollTop,u&&(C(f,l,a),r.trigger(n,"drag",{mouseX:p,mouseY:d,startLeft:w,startTop:E,event:t}))}function L(t){var i=t||event;N(!0),r.trigger(n,"mousedown",i);if(e.style.position!=="absolute"){e.style.position="absolute";return}p=i.pageX||i.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,d=i.pageY||i.clientY+document.body.scrollTop+document.documentElement.scrollTop,w=e.offsetLeft,E=e.offsetTop,h=w,c=E,b=r.addDomListener(T,"mousemove",k),e.setCapture&&e.setCapture(),i.preventDefault?(i.preventDefault(),i.stopPropagation()):(i.cancelBubble=!0,i.returnValue=!1),u=!0,r.trigger(n,"dragstart",{mouseX:p,mouseY:d,startLeft:w,startTop:E,event:i})}function A(t){var i=t||event;u&&(N(!1),r.removeListener(b),e.releaseCapture&&e.releaseCapture(),u=!1,r.trigger(n,"dragend",{mouseX:p,mouseY:d,startLeft:w,startTop:E,event:i})),f=l=null,r.trigger(n,"mouseup",i)}var n=this,r=window.GEvent||google.maps.Event||google.maps.event,i=t||{},s=i.draggingCursor||"default",o=i.draggableCursor||"default",u=!1,a,f,l,c,h,p,d,v,m,g,y,b,w,E,S=Math.round(i.intervalX/2),x=Math.round(i.intervalY/2),T=e.setCapture?e:document;typeof i.intervalX!="number"&&(i.intervalX=1),typeof i.intervalY!="number"&&(i.intervalY=1),typeof i.toleranceX!="number"&&(i.toleranceX=Infinity),typeof i.toleranceY!="number"&&(i.toleranceY=Infinity),g=r.addDomListener(e,"mousedown",L),y=r.addDomListener(T,"mouseup",A),N(!1),i.container,e.style.position="absolute",i.left=i.left||e.offsetLeft,i.top=i.top||e.offsetTop,i.interval=i.interval||1,C(i.left,i.top,!1),n.moveTo=function(e){C(e.x,e.y,!1)},n.moveBy=function(t){C(e.offsetLeft+t.width,e.offsetHeight+t.height,!1)},n.setDraggingCursor=function(e){s=e,N(u)},n.setDraggableCursor=function(e){o=e,N(u)},n.left=function(){return m},n.top=function(){return v},n.valueX=function(){var e=i.intervalX||1;return Math.round(m/e)},n.valueY=function(){var e=i.intervalY||1;return Math.round(v/e)},n.setValueX=function(e){C(e*i.intervalX,v,!1)},n.setValueY=function(e){C(m,e*i.intervalY,!1)},n.preventDefaultMovement=function(e){a=e}};