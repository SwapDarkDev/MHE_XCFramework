
var currentZoomScale=1.0;
var lastTap = 0;
var prevItem;
var doubleTappedElement;

// Set font size
function setFontSize(classes) {
    //alert("FontSize");
    var elm = document.getElementsByTagName( 'html' )[0];
    removeClass(elm, "mediumFont");
    removeClass(elm, "smallFont");
    removeClass(elm, "largeFont");
    removeClass(elm, "xLargeFont");
    removeClass(elm, "xxLargeFont");
    addClass(elm, classes);
    //updateAllsticks();
    //updatefonts(document,classes);
}

function updatefont(root,fontType)
{
    if (root.nodeType == 3) // text node
    {
        addfont(root,fontType);
        return;
    }
    var children = root.childNodes;
    for (var i = children.length - 1 ; i >= 0 ; i--)
    {
        updatefont(children[i],fontType);
    }
}

function addfont(ele,fontType){
    
    var parent = ele.parentNode;
    var ele =parent;
    var type = fontType;
    switch (fontType) {
        case 'xxSmallFont':
            type = "xx-small";
            break;
        case 'xSmallFont':
            type = "x-small";
            break;
        case 'smallFont':
            type = "small";
            break;
        case 'mediumFont':
            type = "medium";
            break;
        case 'largeFont':
            type = "large";
            break;
        case 'xLargeFont':
            type = "x-large";
            break;
        case 'xxLargeFont':
            type = "xx-large";
            break;
    }
    ele.setAttribute('style','font-size:'+type);
}

function updatefonts(doc,fontType){
    updatefont(doc.body,fontType);
}



// Toggle Reader mode
function setReaderMode(classes) {
    var elm = document.documentElement;
    removeClass(elm, "nightMode");
    removeClass(elm, "sepiaMode");
    addClass(elm, classes);
}

// Change Textalignment
function setTextAlignment(classes){
    var elm = document.documentElement;
    removeClass(elm, "leftAlign");
    removeClass(elm, "rightAlign");
    removeClass(elm, "centerAlign");
    removeClass(elm, "justifyAlign");
    addClass(elm, classes);
}

function setLineSpacing(classes){
    var elm = document.documentElement;
    removeClass(elm, "smallLineSpacing");
    removeClass(elm, "mediumLineSpacing");
    removeClass(elm, "largeLineSpacing");
    addClass(elm, classes);
}


// MathJAX loading completed
function mathRenderingCompleted(){
    window.location = "mathload:completed"; 
}

//Transform Containt to Containter Size
function scaleContentToContainerSize(requiredHeight,requiredWidth)
{
    var currentHeight = document.body.clientHeight;
    var currentWidth = document.body.clientWidth;
    
    var viewportContentArray =document.querySelector("meta[name=viewport]").getAttribute("content").split(",")
    var i=0;
    for (i=0;i<viewportContentArray.length;i++)
    {
        var property=viewportContentArray[i].split("=")[0].replace(/\s/g, "").toLowerCase();
        if(property=="height")
        {
           currentHeight=viewportContentArray[i].split("=")[1];
        }
        else if(property=="width")
        {
            currentWidth=viewportContentArray[i].split("=")[1];
        }
    }
    if(isNaN(currentWidth))
    {
        currentWidth = document.body.clientWidth;
    }
    
    if(isNaN(currentHeight))
    {
        currentHeight = document.body.clientHeight;
    }
    //Try Scale to Height, if fails, do fit to width
    //Fit to Height
    var scalePercentage= ((requiredHeight*100)/currentHeight)/100;
    if((scalePercentage*currentWidth)>requiredWidth)
    {
        //Fit to Width
        scalePercentage= ((requiredWidth*100)/currentWidth)/100;
    }
    
    document.body.style.transform="scale("+scalePercentage+")";
    document.body.style.webkitTransform="scale("+scalePercentage+")";
    document.body.style.transformOrigin = "top left";
    document.body.style.webkitTransformOrigin = "top left";
   // document.body.style.marginTop=topMargin+"px";
   // document.body.style.marginLeft= leftMargin+"px";
    
    var newHeight =  Math.round(document.body.getBoundingClientRect().height+0.01);
    var newWidth = Math.round(document.body.getBoundingClientRect().width+0.01);
    var htmlContentWidthHeight=newWidth.toString()+","+newHeight.toString();
    return htmlContentWidthHeight;
}

function getPageSize()
{
    var currentHeight = document.body.clientHeight;
    var currentWidth = document.body.clientWidth;
    
    var viewportContentArray =document.querySelector("meta[name=viewport]").getAttribute("content").split(",")
    var i=0;
    for (i=0;i<viewportContentArray.length;i++)
    {
        var property=viewportContentArray[i].split("=")[0].replace(/\s/g, "").toLowerCase();
        if(property=="height")
        {
            currentHeight=viewportContentArray[i].split("=")[1];
        }
        else if(property=="width")
        {
            currentWidth=viewportContentArray[i].split("=")[1];
        }
    }
    var htmlContentWidthHeight=currentWidth.toString()+","+currentHeight.toString();
    
    return htmlContentWidthHeight;
}


function scaleContentToContainerSize(requiredHeight,requiredWidth)
{
    var currentHeight = document.body.clientHeight;
    var currentWidth = document.body.clientWidth;
    
    var viewportContentArray =document.querySelector("meta[name=viewport]").getAttribute("content").split(",")
    var i=0;
    for (i=0;i<viewportContentArray.length;i++)
    {
        var property=viewportContentArray[i].split("=")[0].replace(/\s/g, "").toLowerCase();
        if(property=="height")
        {
            currentHeight=viewportContentArray[i].split("=")[1];
            if(document.body.clientHeight == 0 || document.body.clientHeight == 1) {
                document.body.style.height = currentHeight + "px";
            }
        }
        else if(property=="width")
        {
            currentWidth=viewportContentArray[i].split("=")[1];
            if(document.body.clientWidth == 0 || document.body.clientWidth == 1) {
                document.body.style.width = currentWidth + "px";
            }
        }
    }
    if(isNaN(currentWidth))
    {
        currentWidth = document.body.clientWidth;
    }
    
    if(isNaN(currentHeight))
    {
        currentHeight = document.body.clientHeight;
    }
    //Try Scale to Height, if fails, do fit to width
    //Fit to Height
    var scalePercentage= ((requiredHeight*100)/currentHeight)/100;
    if((scalePercentage*currentWidth)>requiredWidth)
    {
        //Fit to Width
        scalePercentage= ((requiredWidth*100)/currentWidth)/100;
    }
    
    document.body.style.transform="scale("+scalePercentage+")";
    document.body.style.webkitTransform="scale("+scalePercentage+")";
    document.body.style.transformOrigin = "top left";
    document.body.style.webkitTransformOrigin = "top left";
    // document.body.style.marginTop=topMargin+"px";
    // document.body.style.marginLeft= leftMargin+"px";
    
    var newHeight =  Math.round(document.body.getBoundingClientRect().height+0.01);
    var newWidth = Math.round(document.body.getBoundingClientRect().width+0.01);
    var htmlContentWidthHeight=newWidth.toString()+","+newHeight.toString();
    return htmlContentWidthHeight;
}


function setEPUBLayout(layout)
{
    var meta = document.createElement("meta");
    meta.setAttribute("name", "epublayout");
    meta.setAttribute("content", layout);
    document.getElementsByTagName("head")[0].appendChild(meta);
    if(layout == "FixedLayout")
    {
        var images = document.getElementsByTagName("img");
        for (var img = 0; img<images.length; img++)
        {
            images[img].draggable = false
        }
        addCSSRuleStyle('html','-webkit-touch-callout:none;overflow: hidden;')
    }
    else
    {
       window.removeEventListener('resize', doOnOrientationChange);
       window.addEventListener('resize', doOnOrientationChange);
    }
}
                          
function getLayout()
{
    try {
        return document.querySelector("meta[name=epublayout]").getAttribute("content");
    }
    catch (err)
    {
        return "";
    }
}

function setCurrentZoomScale(zoomScale)
{
    currentZoomScale=zoomScale;
}

var IsTwoPageModeEnable;
function enableTwoPageModeWithPageSeperation(enable)
{
    IsTwoPageModeEnable = true;
    var requiredHeight = window.innerHeight;
    var requiredWidth = (window.innerWidth/2);
    if(enable == true)
    {
        addCSSRuleStyle('html', 'height:' + requiredHeight + 'px; column-gap: 0px; column-width:' + requiredWidth + 'px; column-rule: 1px solid #A9A9A9;');
    }
    else
    {
        addCSSRuleStyle('html', 'height:' + requiredHeight + 'px; column-gap: 0px; column-width:' + requiredWidth + 'px;');
    }
}
                         
/*Because we are not getting correct inner height and width for diable two page mode.*/
var requiredCurrentHeight = window.innerHeight;
var requiredCurrentWidth = window.innerWidth;
function disableTwoPageMode()
{
    IsTwoPageModeEnable = false;
    var requiredHeight = window.innerHeight;
    var requiredWidth = window.innerWidth;
    if (isIPAD()){
        if (requiredHeight<=requiredWidth){
            requiredHeight = Math.max(requiredCurrentHeight, requiredCurrentWidth);
            requiredWidth = Math.min(requiredCurrentHeight, requiredCurrentWidth);
        }
    }
    addCSSRuleStyle('html', 'height:' + requiredHeight + 'px; column-gap: 0px; column-width:' + requiredWidth + 'px;');
    //Remove the added empty page, when two page is disabled.
    var element = document.getElementById('kitabooemptypage');
    if (element)
    {
        element.parentNode.removeChild(element);
    }
     var element = document.getElementById('kitabooemptypagelast');
     if (element)
     {
         element.parentNode.removeChild(element);
     }
}

function setBottomMargin(){
    document.body.style.marginBottom = "25px";
}
                         
function setMargin(marginValue){
    if(marginValue == "")
    {
        document.body.style.marginLeft = "";
        document.body.style.marginRight = "";
    }
    else
    {

        document.body.style.marginLeft = marginValue + "px";
        document.body.style.marginRight = marginValue + "px";
    }
}
                         
 function setAuthorKitabooMargin(marginValue){
    var suggestedDefaultMargin = "";
    try
    {
        if (marginValue == "IOSKitabooDefaultMargin") {
            suggestedDefaultMargin = marginValue = "";
        }
        window.kitabooMarginChange(marginValue);
    }
    catch(err)
    {
        
    }
    return suggestedDefaultMargin;
}

function setWebViewSettings(enable)
{
    if(enable == "true")
    {
        document.body.style.webkitUserSelect = "auto";
        document.body.style.webkitTouchCallout = "auto";
    }else
    {
        document.body.style.webkitUserSelect = "none";
        document.body.style.webkitTouchCallout = "none";
    }
}

function addEmptyPage()
{
    //If empty page is aleardy represented, return.
    var element = document.getElementById('kitabooemptypage');
    if (element)
    {
        return;
    }
    
    //Add empty page if it is not presented.
    var emptypage = document.createElement('div');
    emptypage.setAttribute('id','kitabooemptypage');
    emptypage.setAttribute('style','height:' + (window.innerHeight - getPadding()) + 'px;display:block;background-color:transparent;');
    document.body.insertBefore(emptypage,document.body.firstChild);
}

function addBlankPageForReflowableBookWhereChapterEnds()
{
 //If empty page is aleardy represented, return.
 var element = document.getElementById('kitabooemptypagelast');
 if (element)
 {
     return;
 }
 
 //Add empty page if it is not presented.
 var emptypage = document.createElement('div');
 emptypage.setAttribute('id','kitabooemptypagelast');
 emptypage.setAttribute('style','height:' + (window.innerHeight - getPadding()) + 'px;display:block;background-color:transparent;');
 document.body.insertBefore(emptypage,document.body.lastChild);
}

function resizeAllTheImages(coverImage)
{
    //Get All the images.
    var images = document.getElementsByTagName("img");
    for (var img = 0; img<images.length; img++)
    {
      if(images[img].id != "modalElement")
      {
        resizeElement(images[img])
        /*To make cover image as center align and not to change alignment as per text alignment, so assigned property block to cover image only.*/
        if (isCoverImage(images[img],coverImage)) {
            resizeElement(document.body)
            images[img].style.display = "block"
        }
      }
    }
}
                         
 function resizeImagesForIphoneLandscape(coverImage)
 {
     //Get All the images.
     var images = document.getElementsByTagName("img");
     for (var img = 0; img<images.length; img++)
     {
       if(images[img].id != "modalElement")
       {
        /*To make cover image as center align and not to change alignment as per text alignment, so assigned property block to cover image only.*/
          if (isCoverImage(images[img],coverImage)) {
            resizeElement(images[img])
            resizeElement(document.body)
            images[img].style.display = "block"
          }else{
            images[img].removeAttribute("style")
         }
      }
     }
 }
                         
 function resizeElement(element){
    if(!isIPAD()) {
        element.setAttribute('style','max-height:' + (window.innerHeight - (getPadding()+30)) +'px !important;height:auto !important;');
    }else {
        element.setAttribute('style','max-height:' + (window.innerHeight - (getPadding()+30)) +'px !important;height:auto !important;');
    }
 }
  
 function isCoverImage(imageElement,coverImage){
     if(coverImage == "")
     {
        return false;
     }
     if (((imageElement.getAttribute('src').includes(coverImage)) || (imageElement.getAttribute('src').includes(coverImage.substr(0, coverImage.lastIndexOf("."))
     ))) || ((imageElement.getAttribute('src') != undefined) && imageElement.getAttribute('src').toLowerCase().includes('images/cover.jpg'))) {
        return true;
     }else{
        return false;
     }
 }
                         
function paginationOff()
{
    IsTwoPageModeEnable = false;
    var stylesheetLength = document.styleSheets.length;
    var stylesheetLastEle = stylesheetLength-1;
    var mySheet = document.styleSheets[stylesheetLastEle];
    if(mySheet.cssRules)
    {
        for (var i = 0; i < mySheet.cssRules.length; i++)
        {
            if (mySheet.cssRules[i].selectorText == 'html')
                mySheet.removeRule(i);
        }
    }
    
    //Remove the added empty page when pagination is off.
    var element = document.getElementById('kitabooemptypage');
    if (element)
    {
        element.parentNode.removeChild(element);
    }
                         
    var element = document.getElementById('kitabooemptypagelast');
    if (element)
    {
        element.parentNode.removeChild(element);
    }
    setBottomMargin();
}


function changeFontFamily(fontFamily)
{
    $("h1,h2,h3,h4,h5,h6,div,p,span,a,td,tr,figcaption,kdn").not( "[class^='icon-']" ).not( "[class$='-icon']" ).not( "[class*='icon']" ).not( "[class*='ignore-activity-classes']" ).not( "[class^='vjs-']" ).css('font-family', fontFamily);
}

function getPadding()
{
    var currentPadding = parseInt(window.getComputedStyle(document.body).paddingTop) + parseInt(window.getComputedStyle(document.body).paddingBottom);
    return currentPadding;
}

function addCSSRuleStyle(selector, newRule)
{
    var stylesheetLength = document.styleSheets.length;
    var stylesheetLastEle = stylesheetLength-1;
    var mySheet = document.styleSheets[stylesheetLastEle];
    if (mySheet != undefined)
    {
        if (mySheet.addRule)
        {
            if(mySheet.cssRules)
            {
                for (var i = 0; i < mySheet.cssRules.length; i++)
                {
                    if (mySheet.cssRules[i].selectorText === 'html')
                    {
                        mySheet.removeRule(i);
                    }
                }
            }
            mySheet.addRule(selector, newRule);
        } else
        {
            ruleIndex = mySheet.cssRules.length;
            mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);
        }
    } else
    {
        console.log('stylesheet not available');
    }
}

function getCFINodeString() {
    var currentrange = document.caretRangeFromPoint(0, 0);
    var cfi = "";
    if (currentrange.startContainer.nodeType == 3 && currentrange.startOffset != 0)
    {
        cfi = EPUBcfi.Generator.generateCharOffsetRangeComponent(currentrange.startContainer, currentrange.startOffset, currentrange.endContainer, currentrange.endOffset, null, null, null);
    }
    else
    {
        var node = getFirstVisibleNode(document.body) || document.body;
        if (node.nodeType === Node.TEXT_NODE)
        {
            cfi = EPUBcfi.Generator.generateCharacterOffsetCFIComponent(node, 0);
        }
        else
        {
            cfi = EPUBcfi.Generator.generateElementCFIComponent(node);
        }
    }
    cfi = EPUBcfi.Generator.generateCompleteCFI("/0!", cfi);
    return cfi;
}

function getViewportRect()
{
    var viewportRectJSon  = '{"x":0,"y":0,"width":'+window.innerWidth+',"height":'+window.innerHeight+'}'
    var viewportRect = constructDOMRect(viewportRectJSon)
    return viewportRect;
}

function constructDOMRect(rectJsonString)
{
    var rectJson = JSON.parse(rectJsonString);
    return new DOMRect(rectJson.x, rectJson.y, rectJson.width,rectJson.height);
}

function getFirstVisibleNode(node) {
    var range = document.createRange();
    range.selectNode(node);
    var rect = RangeFix.getBoundingClientRect(range);
    if (rect == null)
        return null;
    var viewportRect = getViewportRect();
    var intersects = rectIntersects(viewportRect, rect);
    var contains = rectContains(viewportRect, rect);
    if (contains)
    {
        return node;
    }
    else if (intersects)
    {
        var childNodes = node.childNodes;
        for (var i = 0; i < childNodes.length; i++)
        {
            if (childNodes[i].nodeType === Node.ELEMENT_NODE || childNodes[i].nodeType === Node.TEXT_NODE)
            {
                var childNode = getFirstVisibleNode(childNodes[i]);
                if (childNode)
                {
                    return childNode;
                }
            }
        }
        return node;
    }
    return null;
}

function rectIntersects(a, b)
{
    return a.left < b.right && b.left < a.right && a.top < b.bottom && b.top < a.bottom;
}

function rectContains(a, b)
{
    // check for empty first
    return a.left < a.right && a.top < a.bottom
    // now check for containment
    && a.left <= b.left && a.top <= b.top && a.right >= b.right && a.bottom >= b.bottom;
}

//jump to cfi
function getOffsetForCFI(CFIString,isForOffsetValue){
    try
    {
        if(!EPUBcfi.isRangeCfi(CFIString))
        {
            var node = EPUBcfi.Interpreter.getTargetElement(CFIString,document,null,null,null);
            var offsetLeft = scrollIntoCFINode(node[0],isForOffsetValue);
            return offsetLeft;
        }
        else
        {
            var range = EPUBcfi.Interpreter.getRangeTargetElements(CFIString,document,null,null,null);
            var finalSafeIndex = 0;
            var startSafeIndex = 0;
            var endSafeIndex = 0;
            var startOffset = 0;
            var endOffset = 0;
            if(range.startElement.length <= range.startOffset)
            {
                for(i=0;i<range.startElement.parentElement.childNodes.length;i++)
                {
                    if(range.startElement.parentElement.childNodes[i]==range.startElement && range.startElement.parentElement.childNodes[i+1])
                        {
                            range = range.startElement.parentElement.childNodes[i+1];
                            var offsetLeft = scrollIntoCFINode(range,isForOffsetValue);
                            return offsetLeft;
                        }
                }
            }
            if(range.startOffset)
            {
                startOffset = range.startOffset;
            }
            else
            {
                startOffset = 0;
            }
            if(range.endOffset)
            {
                endOffset = range.endOffset;
            }
            else
            {
                endOffset = 0;
            }
            if(range.startElement.length > 0 && range.startElement.length != range.startOffset && range.startElement.length > startOffset)
            {
                var substringLength = range.startElement.length - startOffset;
                var substringValue = range.startElement.substringData(startOffset,substringLength);
                var trimmedString = substringValue.trim();
                var spaceIndex = trimmedString.indexOf(" ");
                var firstWord = trimmedString.substring(0,spaceIndex);
                var firstWordIndex = substringValue.indexOf(firstWord);
                finalSafeIndex = firstWordIndex + firstWord.length;
                startSafeIndex = startOffset + finalSafeIndex;
                endSafeIndex = endOffset + finalSafeIndex;
            }
            else if(range.startElement.length <= startOffset)
            {
                startSafeIndex = range.startElement.length;
                endSafeIndex = range.startElement.length;
            }
            var convertedrange = document.createRange();
            convertedrange.setStart(range.startElement, startSafeIndex);
            convertedrange.setEnd(range.endElement, endSafeIndex);
            var dummylastvisiter = document.createElement('span');
            dummylastvisiter.setAttribute('style','position:-webkit-sticky;height: 0px; width: 0px; overflow: hidden; float: none;  display: inline-block; clear: both;');
            convertedrange.cloneRange().surroundContents(dummylastvisiter);
            var offsetLeft = scrollIntoCFINode(dummylastvisiter,isForOffsetValue);
            var pa = dummylastvisiter.parentNode;
            while (dummylastvisiter.firstChild) pa.insertBefore(dummylastvisiter.firstChild, dummylastvisiter);
            pa.removeChild(dummylastvisiter);
            pa.normalize();
            return offsetLeft;
        }
    }
    catch (err)
    {
        return 0;
    }
}

//scroll in to cfi node
function scrollIntoCFINode(nodeOrRange,isForOffsetValue)
{
    var scrollingElement = bodyOrHtml();
    // For Direction.VERTICAL
    var nodeOffsetTop, nodeOffsetHeight;
    // For Direction.HORIZONTAL
    var nodeOffsetLeft;
    if (nodeOrRange instanceof Range || nodeOrRange.nodeType === Node.TEXT_NODE) {
        var rect;
        if (nodeOrRange.nodeType && nodeOrRange.nodeType === Node.TEXT_NODE) {
            var range = document.createRange();
            range.selectNode(nodeOrRange);
            rect = RangeFix.getBoundingClientRect(range);
        } else {
            rect = RangeFix.getBoundingClientRect(nodeOrRange);
        }
        //return left or top as per requirement
        nodeOffsetTop = scrollingElement.scrollTop + rect.top;
        nodeOffsetHeight = rect.height;
        nodeOffsetLeft = scrollingElement.scrollLeft + rect.left;
        if(isForOffsetValue == "true")
        {
            return nodeOffsetTop;
        }
        if(scrollEnabled == "true")
        {
            return nodeOffsetLeft;
        }
        else
        {
            return nodeOffsetTop;
        }
        
    } else if (nodeOrRange.nodeType === Node.ELEMENT_NODE) {
        //return left or top as per requirement
        try
        {
            var absoluteOffset = getAbsPosition(nodeOrRange);
            nodeOffsetTop = absoluteOffset[1];
        }
        catch(err)
        {
            nodeOffsetTop = nodeOrRange.offsetTop;
        }
        nodeOffsetHeight = nodeOrRange.offsetHeight;
        nodeOffsetLeft = nodeOrRange.offsetLeft;
        if(scrollEnabled != "true")
        {
            return nodeOffsetTop;
        }
    } else {
        throw("-> Illegal Argument Exception, nodeOrRange -> " + nodeOrRange);
    }
    if(isForOffsetValue == 'true')
    {
        var pageValue = Math.floor(nodeOffsetTop/window.innerHeight);
        var offsetVal = nodeOffsetTop - pageValue;
        return offsetVal;
    }
    
                          
    var highlightOffSet = nodeOffsetTop;
    var pageNumber = Math.floor(highlightOffSet/window.innerHeight);
    var leftMargin = 0;
    var topMargin = 0;
    if(IsTwoPageModeEnable)
    {
        pageNumber = pageNumber/2;
    }
    leftMargin = (pageNumber)*(window.innerWidth);
    return leftMargin;
}

// TODO -> Check if this is required?
function bodyOrHtml() {
    if ('scrollingElement' in document)
    {
        return document.scrollingElement;
    }
    if (navigator.userAgent.indexOf('WebKit') != -1)
    {
        return document.body;
    }
    return document.documentElement;
}

function isCFIContextBookmarked(CFINodeOrRange)
{
    var value = getOffsetForCFI(CFINodeOrRange,'false');

    if(scrollEnabled == "true")
    {
        var CFIPage = Math.floor(value/window.innerWidth);
                                 
        var actualPosition = value/window.innerWidth;
        if((actualPosition-CFIPage)>0.8)
        {
            CFIPage = CFIPage+1;
        }
        
        var currPage = Math.floor(window.pageXOffset/window.innerWidth);
        
        if(CFIPage == currPage)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    else
    {
        var minValue = window.pageYOffset;
        var maxValue = minValue + window.innerHeight;
        if(value >= minValue && value < maxValue)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
                                  
function getCurrentVisibleCFIs()
{
  var allCFIElements = document.querySelectorAll('[data-cfi]')
  var currentCFIList = [];
  for (var i = 0; i < allCFIElements.length; i++) {
      var elem = allCFIElements[i];
      if(isInViewRect(elem) && !((elem.style.display === 'none') || (elem.style.visibility === 'hidden')))
      {
          var cfiString = elem.getAttribute('data-cfi');
          currentCFIList.push(cfiString);
      }
  }
  return currentCFIList.toString();
}

function disableScrollMode()
{
    var elm = document.documentElement;
    removeClass(elm, "disableScrollClass");
    addClass(elm, "disableScrollClass");
}
                                  
function enableScrollMode()
{
    var elm = document.documentElement;
    removeClass(elm, "disableScrollClass");
}
                                  
function doOnOrientationChange() {
  setTimeout(function() {
     window.location = "orientationchange";
  }, 200);
}

function setClickEventForElementModal(coverImage)
{
    var images = document.getElementsByTagName("img");
    for (var img = 0; img<images.length; img++)
    {
      if(images[img].id != "modalElement" && !isCoverImage(images[img],coverImage))
      {
        images[img].setAttribute('onclick',"elementClicked(event)");
        images[img].style.pointerEvents = "";
      }
    }
    var tables = document.getElementsByTagName("table");
    for (var table = 0; table<tables.length; table++)
    {
      if(tables[table].id != "modalElement")
      {
        tables[table].setAttribute('onclick',"elementClicked(event)");
        tables[table].style.pointerEvents = "";
      }
    }
}

function elementClicked(event)
{
    var currentTime = new Date().getTime();
    var tapLength = currentTime - lastTap;
    if (tapLength < 500 && tapLength > 0 && prevItem == event.currentTarget)
    {
        var targetElement = event.currentTarget;
        if(targetElement.tagName.toLowerCase() == "img")
        {
            var captionText = getCaptionForElement(targetElement,document);
            var jsonString = JSON.stringify({
            path: targetElement.src,
            caption: captionText
            });
            window.location = "LoadImageModalPopUP:" + jsonString;
        }
        else
        {
            doubleTappedElement = event.currentTarget;
            window.location = "elementDoubleTapped";
        }
    }
    lastTap = currentTime;
    prevItem = event.currentTarget;
}
                                  
function openModalPopup(elementBackGroundColor,popupBackgroundColor)
{
    if(doubleTappedElement)
    {
        var captionText="";
        var modalPopup = document.getElementById("modalPopup");
        if(modalPopup != undefined)
        {
            modalPopup.parentElement.removeChild(modalPopup);
        }
        modalPopup = document.createElement("div");
        modalPopup.className = "modalPopup";
        modalPopup.setAttribute('id',"modalPopup");
        modalPopup.setAttribute('style','background-color:'+ popupBackgroundColor +' !important;');
        var modalChild = document.createElement("div");
        modalChild.className = "modalChild";
        var closeSpan = document.createElement("span");
        closeSpan.className = "modalCloseSpan";
        closeSpan.textContent = "2";
        closeSpan.setAttribute('onclick',"closeModalPopup(event)");
        var elementDiv = document.createElement("div");
        var elementCopy = doubleTappedElement.cloneNode(true);
        elementCopy.removeAttribute("onclick");
        elementCopy.style.height = "";
        elementCopy.style.width = "";
        elementCopy.id = "modalElement";
        if(elementCopy.tagName.toLowerCase() == "table")
        {
            elementCopy.classList.add("modalChild");
            var highlights = elementCopy.getElementsByTagName("highlightmark");
            var highlightsLength=highlights.length;
            for (var i = 0; i < highlightsLength; i++)
            {
                var highlightElement = highlights[0];
                var parentElement = highlightElement.parentElement;
                while (highlightElement.firstChild){
                    parentElement.insertBefore(highlightElement.firstChild, highlightElement);
                    parentElement.removeChild(highlightElement);
                    parentElement.normalize();
                }
            }
        }
        else
        {
            elementCopy.className = "modalChild";
        }
        var modalCaptionText = document.createElement("p");
        modalCaptionText.textContent = captionText;
        modalCaptionText.className = "modalCaptionClass";
                                  
        modalPopup.appendChild(modalChild);
        modalChild.appendChild(closeSpan);
        modalChild.appendChild(elementDiv);
        if(captionText == "")
        {
            elementDiv.className = "modalElementDiv";
        }
        else
        {
            elementDiv.className = "modalElementDivWithCaption";
            modalChild.appendChild(modalCaptionText);
        }
        elementDiv.appendChild(elementCopy);
        document.body.appendChild(modalPopup);
        modalChild.setAttribute('style','background-color:'+popupBackgroundColor+' !important;');
        elementDiv.setAttribute('style','background-color:'+elementBackGroundColor+' !important;');
        modalPopup.style.display= "block";
        window.location = "modalPopupOpened"
    }
}
                                  
function getCaptionForElement(ele, doc){
    var _eleParent = ele;
    var _caption = "";
    try
    {
          while(_eleParent.nextElementSibling === null && _eleParent != doc.body){
          _eleParent = _eleParent.parentElement;
          }
          if(_eleParent != doc.body) {
          _caption = (_eleParent.nextElementSibling && _eleParent.parentElement.innerText.trim().endsWith(_eleParent.nextElementSibling.innerText.trim())) ? _eleParent.nextElementSibling.innerText.trim() : (_eleParent.parentElement.innerText.trim().startsWith(_eleParent.nextElementSibling.innerText.trim())) ? _eleParent.parentElement.innerText.trim() : _eleParent.innerText.trim();
          }
    }
    catch (err)
    {
        return "";
    }
   return _caption;
}
                                  
function closeModalPopup(event)
{
    var modalPopup = document.getElementById("modalPopup");
    modalPopup.style.display= "";
    modalPopup.parentElement.removeChild(modalPopup);
    doubleTappedElement = null;
    window.location = "modalPopupClosed";
}
                                  
function loadPopup(id,title,url)
{
    if(getLayout() == "FixedLayout") {
        var jsonString = JSON.stringify({
        resourceId: id,
        resourceTitle: title,
        resourceURL: url
        });
        window.location = "LoadPopUP:" + jsonString;
    } else {
    window.location = "LoadPopUP:" + url;
    }
}
                                  
function setTouchEndEvent(){
  $(document).on('touchend touchcancel', function(elem) {
      touchend(elem)
  });
}

function touchend(elem){
  if(elem.target){
      if(elem.target.id){
          var wordInnerText = elem.target.innerText;
          var jsonString = JSON.stringify({
          wordId: elem.target.id,
          wordText: wordInnerText
          });
          window.location = "wordClicked:" + jsonString;
      }
      else if(elem.target.parentElement.id){
          var wordInnerText = elem.target.parentElement.innerText;
          var jsonString = JSON.stringify({
          wordId: elem.target.parentElement.id,
          wordText: wordInnerText
          });
          window.location = "wordClicked:" + jsonString;
      }
  }
}
                                  
function jumpToBookCFI(bookCFI)
{
    var selectorString = "[data-cfi='" + bookCFI +"']";
    var modalPopup = document.querySelector(selectorString);
    if(modalPopup)
    {
        scrollElementInToView(modalPopup);
    }
}
                                  
function addWatermark(watermarktext,textColor)
{
    removeWatermark();
    var topValue = 500;
    var areaPerPage = 600000;
    var pageArea = document.body.clientHeight * document.body.clientWidth;
    var watermarkCount = pageArea/areaPerPage;
    if((watermarkCount-Math.floor(watermarkCount))<0.5)
    {
        watermarkCount = Math.ceil(watermarkCount);
    } else {
        watermarkCount = Math.ceil(watermarkCount) + 1;
    }
    for (var i = 0 ; i < watermarkCount ; i++)
    {
        var watermarkTextView = document.createElement("kitaboowatermark");
        watermarkTextView.style.color = textColor;
        watermarkTextView.innerText = watermarktext;
        watermarkTextView.style.top = topValue + "px";
        document.body.appendChild(watermarkTextView);
        topValue = topValue + 1000;
    }
}
                                  
function removeWatermark()
{
    var watermarks = document.getElementsByTagName("kitaboowatermark");
    var watermarkCount = watermarks.length
    for (var i = 0; i<watermarkCount; i++)
    {
        var watermark = watermarks[0];
        watermark.parentElement.removeChild(watermark);
    }
}
