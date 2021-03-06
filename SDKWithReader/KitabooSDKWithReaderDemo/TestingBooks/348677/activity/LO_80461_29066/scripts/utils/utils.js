function BatchLoader(a) {
    this.dispatcher = a, this.fileURLs = [], this.files = [], this.fileContents = [], this.filesUrlDocMap = {}, this.checkFinished = function() {
        if (this.files.length == this.fileURLs.length) {
            var a = this;
            $(a.fileURLs).each(function() {
                var b = this;
                $(a.files).each(function() {
                    b == this.url && (a.fileContents.push(this), a.filesUrlDocMap[this.url] = this.data)
                })
            });
            var b = jQuery.Event(BatchLoader.LOAD_COMPLETE);
            b.fileContents = this.fileContents, b.filesUrlDocMap = this.filesUrlDocMap, $(this).trigger(b)
        }
    }
}

function ClientInformation() {}

function CollectionUtils() {}

function ContainerUtils() {}

function FileUtils() {}

function TLFToHTMLAdapter() {}

function TLFToPlainTextAdapter() {}

function URLUtils() {}

function createAbsolutePath(a, b, c) {
    return window.location.href.split(a)[0] + b.split(c)[1]
}

function mediaImage() {}

function getImageWidth(a) {
    var b = $(a).width();
    return !b && $(a).data("actualWidth") && (b = $(a).data($(a).data("actualWidth") > $(a).data("maxPossibleWidth") ? "maxPossibleWidth" : "actualWidth")), b
}

function addZoom(a) {
    if ($(a).data("maxPossibleWidth") < $(a).data("actualWidth") - mediaImage.zoomThreshold) {
        if (0 == $(a).parent().find(".zoomIcon").length) {
            var b = $("<a titleLocale='title' rel='localize[zoom]' class='zoomIcon' />");
            $(b).css("cursor", "pointer"), $(a).parent().append(b), $(a).data("maxPossibleWidth") <= 50 && $(b).addClass("smallZoomIcon"), $(b).bind((Modernizr.touch ? "touchstart" : "click") + " enter", function() {
                function b() {
                    var d = new Image;
                    $(d).load(function() {
                        var c = $('<img class="zoomIconWrapper" width="' + d.width + '" height="' + d.height + '" src="' + $(a).attr('src') + '" />');
                        setTimeout(function() {
                            $.colorbox($.extend({}, colorBoxConfiguration, {
                                href: c,
                                onComplete: onModalComplete,
                                onCleanup: function() {
                                    onModalCleanUp(), document.getElementById("cboxLoadedContent").style.setProperty("overflow-x", "hidden", "important"), $(document).unbind("cbox_closed", b)
                                },
                                onClosed: function() {
                                    onModalClose(), $(c).focus()
                                }
                            })), document.getElementById("cboxLoadedContent").style.setProperty("overflow-x", "auto", "important")
                        }, 10)
                    }), d.src = c
                }
                var c = $(a).attr("src");
                $("#cboxLoadedContent").children().length > 0 ? ($(document).bind("cbox_closed", b), $.colorbox.close()) : b()
            });
            var c = 0;
            c = $(a).closest(".mediaWrapper").find(".caption").size() > 0 ? parseInt($(a).closest(".mediaWrapper").find(".caption").attr("tabindex")) + 1 : parseInt($(a).attr("tabindex")) + 1;
            var b = $(a).parent().find("a.zoomIcon");
            ClientInformation.isMobileDevice() ? ClientInformation.isIPad() && $(b).bind("touchstart", function(a) {
                a.stopPropagation()
            }) : ($(b).enterEnabled(), $(b).bind("enter", function() {
                $(b).click(), window.open($(b).attr("href"))
            }), $(b).attr("tabindex", c))
        }
    } else $(a).parent().find("a.zoomIcon").remove()
}

function setMaxImageWidthFor(a) {
    var b = null,
        c = null;
    b = $(a).closest(".mediaWrapper"), c = $(a).closest(".imageDataGroup"), 0 == $(b).size() && (b = $(a).parent());
    var d = parseInt($(b).css("width")),
        e = parseInt($(b).css("max-width")),
        f = parseInt($(c).css("max-width")),
        g = $(b).width(),
        h = null;
    e && !isNaN(e) ? h = e : f && !isNaN(f) ? h = f : d && !isNaN(d) ? h = d : g && !isNaN(g) && (h = g);
    var i = [],
        j = a;
    do i.push(j), j = $(j).parent(); while ($(j).get(0) != $(b).get(0));
    var k = 0;
    $(i).each(function() {
        k += ContainerUtils.getLeftGutter(this, !0) + ContainerUtils.getRightGutter(this, !0)
    }), k += ContainerUtils.getLeftGutter($(b), !1) + ContainerUtils.getRightGutter($(b), !1);
    var l = $(window).width();
    "MATCH_PAIRS_DRAW_LINES" == dataObject.templateIdentifier ? l > 768 ? ($(a).css("max-width", "365px"), $(a).data("maxPossibleWidth", 365)) : ($(a).css("max-width", "150px"), $(a).data("maxPossibleWidth", 150)) : h && ($(a).css("max-width", h - k + "px"), $(a).data("maxPossibleWidth", h - k))
}

function shuffleProperties(a) {
    var b = {},
        c = getKeys(a);
    c.shuffle();
    for (var d in c) "shuffle" != d && (b[c[d]] = a[c[d]]);
    return b
}

function getKeys(a) {
    var b = new Array;
    for (var c in a) b.push(c);
    return b
}

function Swipe(a, b, c, d, e) {
    this.onLeft = b, this.onRight = c, this.onUp = d, this.onDown = e, this.reset();
    var f = this;
    a.addEventListener("touchstart", function(a) {
        1 == a.touches.length ? (a.preventDefault(), f.startX = a.touches[0].pageX, f.startY = a.touches[0].pageY) : f.reset()
    }, !1), a.addEventListener("touchmove", function(a) {
        1 == a.touches.length ? (a.preventDefault(), f.curX = a.touches[0].pageX, f.curY = a.touches[0].pageY) : f.reset()
    }, !1), a.addEventListener("touchend", function(a) {
        if (0 != f.curX)
            if (f.getSwipeLength() >= Swipe.MIN_LENGTH) {
                a.preventDefault();
                var b = f.getSwipeAngle(),
                    c = f.getSwipeDirection(b);
                f.dispatchEvent(c), f.reset()
            } else f.reset();
        else f.reset()
    }, !1), this.touchCancel = function() {
        f.reset()
    }
}
BatchLoader.LOAD_COMPLETE = "loadComplete", BatchLoader.prototype.dispatcher = null, BatchLoader.prototype.loadFiles = function(a) {
    this.fileURLs = a;
    var b = this;
    $(a).each(function(a, c) {
        $.ajax({
            url: c,
            dataType: "xml",
            success: function(a) {
                b.files.push({
                    url: c,
                    data: a
                }), b.checkFinished()
            },
            error: function() {
                b.files.push({
                    url: c,
                    data: null
                }), b.checkFinished()
            }
        })
    })
};
var isMobileDevice = null;
ClientInformation.isIPad = function() {
        return navigator.userAgent.match(/iPad/i) ? !0 : !1
    }, ClientInformation.iOSVersion = function() {
        return ClientInformation.isIPhone() || ClientInformation.isIPad() ? navigator.userAgent.match(/OS 4/i) ? 4 : navigator.userAgent.match(/OS 5/i) ? 5 : 9999 : 9999
    }, ClientInformation.isIPhone = function() {
        return navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i) ? !0 : !1
    }, ClientInformation.isAndroidDevice = function() {
        var a = navigator.userAgent.toLowerCase();
        return a.indexOf("android") > -1 || a.indexOf("linux") > -1 ? !0 : !1
    }, ClientInformation.isMobileDevice = function() {
        if (null == isMobileDevice) {
            {
                navigator.userAgent.toLowerCase()
            }
            isMobileDevice = ClientInformation.isIPad() || ClientInformation.isIPhone() || ClientInformation.isAndroidDevice() ? !0 : !1
        }
        return isMobileDevice
    }, ClientInformation.getScreenResolutionX = function() {
        var a = 0;
        return a = "undefined" != typeof window.innerWidth ? window.innerWidth : "undefined" != typeof document.documentElement && "undefined" != typeof document.documentElement.clientWidth && 0 != document.documentElement.clientWidth ? document.documentElement.clientWidth : document.getElementsByTagName("body")[0].clientWidth
    }, ClientInformation.getScreenResolutionY = function() {
        var a = 0;
        return a = "undefined" != typeof window.innerHeight ? window.innerHeight : "undefined" != typeof document.documentElement && "undefined" != typeof document.documentElement.clientHeight && 0 != document.documentElement.clientHeight ? document.documentElement.clientHeight : document.getElementsByTagName("body")[0].clientHeight
    }, CollectionUtils.findElementWithProperty = function(a, b, c) {
        var d = null;
        return $(c).each(function() {
            return this[a] == b ? (d = this, !1) : void 0
        }), d
    }, ContainerUtils.getPositionInParent = function(a) {
        var b = $($(a).parent()).offset(),
            c = $(a).offset(),
            d = {
                top: c.top - b.top,
                left: c.left - b.left
            };
        return d
    }, ContainerUtils.getTopGutter = function(a, b) {
        var c = 0,
            d = parseInt($(a).css("padding-top"));
        isNaN(d) || (c += d);
        var e = parseInt($(a).css("border-top-width"));
        if (isNaN(e) || (c += e), b && $(a).css("margin-top")) {
            var f = parseInt($(a).css("margin-top"));
            isNaN(f) || (c += f)
        }
        return c
    }, ContainerUtils.getRightGutter = function(a, b) {
        var c = 0,
            d = parseInt($(a).css("padding-right"));
        isNaN(d) || (c += d);
        var e = parseInt($(a).css("border-right-width"));
        if (isNaN(e) || (c += e), b && $(a).css("margin-right")) {
            var f = parseInt($(a).css("margin-right"));
            isNaN(f) || (c += f)
        }
        return c
    }, ContainerUtils.getBottomGutter = function(a, b) {
        var c = 0,
            d = parseInt($(a).css("padding-bottom"));
        isNaN(d) || (c += d);
        var e = parseInt($(a).css("border-bottom-width"));
        if (isNaN(e) || (c += e), b && $(a).css("margin-bottom")) {
            var f = parseInt($(a).css("margin-bottom"));
            isNaN(f) || (c += f)
        }
        return c
    }, ContainerUtils.getLeftGutter = function(a, b) {
        var c = 0,
            d = parseInt($(a).css("padding-left"));
        isNaN(d) || (c += d);
        var e = parseInt($(a).css("border-left-width"));
        if (isNaN(e) || (c += e), b && $(a).css("margin-left")) {
            var f = parseInt($(a).css("margin-left"));
            isNaN(f) || (c += f)
        }
        return c
    },
    function(a) {
        a.fn.enterEnabled = function(b) {
            var c = 13,
                d = 32;
            element = this, 1 != a(element).data("isEnterEnabled") && (a(this).bind("keypress", function(e) {
                e.stopPropagation();
                var f = e.keyCode ? e.keyCode : e.which;
                if (b && b.spaceOnly) {
                    if (f == d) {
                        var g = jQuery.Event("enter");
                        a(this).trigger(g)
                    }
                } else if (f == c || f == d) {
                    var g = jQuery.Event("enter");
                    a(this).trigger(g)
                }
            }), a(element).data("isEnterEnabled", !0))
        }
    }(jQuery), FileUtils.extractFileExtension = function(a) {
        var b = /(?:\.([^\.]+))?$/,
            c = b.exec(a)[1];
        return c || (c = ""), c
    }, FileUtils.extractFileNameWithoutExtension = function(a) {
        var b = "",
            c = /(.*)\.[^.]+$/;
        return a.match(c) && (b = RegExp.$1), b || (b = ""), b
    },
    function(a) {
        a.fn.makeFocusOutDirectionEnabled = function() {
            var b = 9;
            element = this, a(this).bind("keydown", function(c) {
                function d() {
                    var b = this;
                    setTimeout(function() {
                        a(b).data("focusOutDirection", ""), a(b).unbind("blur", d)
                    }, 100)
                }
                var e = c.keyCode ? c.keyCode : c.which;
                e == b && (c.shiftKey ? a(this).data("focusOutDirection", -1) : a(this).data("focusOutDirection", 1), a(this).bind("blur", d))
            })
        }, a.fn.focusOutDirection = function() {
            return -1 == a(this).data("focusOutDirection") ? -1 : 1 == a(this).data("focusOutDirection") ? 1 : 0
        }
    }(jQuery), $.globalToLocal = function(a, b, c) {
        var d = a.offset();
        return {
            x: Math.floor(b - d.left),
            y: Math.floor(c - d.top)
        }
    }, jQuery.localToGlobal = function(a, b, c) {
        var d = a.offset();
        return {
            x: Math.floor(b + d.left),
            y: Math.floor(c + d.top)
        }
    }, $.fn.globalToLocal = function(a, b) {
        return $.globalToLocal(this.first(), a, b)
    }, $.fn.localToGlobal = function(a, b) {
        return $.localToGlobal(this.first(), a, b)
    },
    function(a) {
        a.fn.restrictMaxImageSizeForMe = function() {
            function b(b) {
                var d = a(b).find("img");
                a(d).each(function() {
                    var b = this;
                    a(b).bind("load", function() {
                        c(b), a(window).bind("resize refresh", function() {
                            c(b)
                        })
                    })
                })
            }

            function c(b) {
                var c = null;
                c = a(b).closest(".mediaWrapper"), 0 == a(c).size() && (c = a(b).closest("#mediaWrapper")), 0 == a(c).size() && (c = a(b).parent());
                var d = parseInt(a(c).css("width")),
                    e = parseInt(a(c).css("max-width")),
                    f = a(c).width(),
                    g = null;
                e && !isNaN(e) ? g = e : d && !isNaN(d) ? g = d : f && !isNaN(f) && (g = f);
                var h = [],
                    i = b;
                do i = a(i).parent(), h.push(i); while (a(i).get(0) != a(c).get(0));
                var j = 0;
                a(h).each(function() {
                    j += ContainerUtils.getLeftGutter(this, !0) + ContainerUtils.getRightGutter(this, !0)
                }), g && a(b).css("max-width", g - j + "px")
            }
            var d = this;
            b(d)
        }
    }(jQuery), TLFToHTMLAdapter.TEXT_FLOW = "TextFlow", TLFToHTMLAdapter.DIV = "div", TLFToHTMLAdapter.P = "p", TLFToHTMLAdapter.A = "a", TLFToHTMLAdapter.IMG = "img", TLFToHTMLAdapter.SPAN = "span", TLFToHTMLAdapter.BR = "br", TLFToHTMLAdapter.TAB = "tab", TLFToHTMLAdapter.LIST = "list", TLFToHTMLAdapter.LIST_ITEM = "li", TLFToHTMLAdapter.convertToHTMLString = function(a) {
        var b = "";
        if (a) {
            a = $.trim(a), a = a.replace(/  /g, "dmmyspc____dummyspc"), a = a.replace(/<tab\/>/g, "dmmyspc____dummyspcdmmyspc____dummyspc");
            var c = $.parseXML(a);
            b = TLFToHTMLAdapter.convertTagToHTMLString($(c).children()[0]), b = b.replace(/<p><\/p>/g, ""), b = b.replace(/dmmyspc____dummyspc/g, "&nbsp;&nbsp;")
        }
        return b
    }, TLFToHTMLAdapter.convertTagToHTMLString = function(a) {
        var b = "",
            c = a;
        if (0 == $(c).children().size()) switch (c.nodeName) {
            case TLFToHTMLAdapter.SPAN:
                if (b = $(c).text(), b || (b = " "), "bold" == $(c).attr("fontWeight") && (b = "<b>" + b + "</b>"), "italic" == $(c).attr("fontStyle") && (b = "<i>" + b + "</i>"), "underline" == $(c).attr("textDecoration") && (b = "<u>" + b + "</u>"), "lowercaseToSmallCaps" == $(c).attr("typographicCase") && ($(c).attr("fontFamily", ""), $(c).attr("fontSize", ""), b = '<span class="smallCapsFormat" style="font-variant: small-caps;">' + b + "</span>"), $(c).attr("color")) {
                    var d = $(c).attr("color");
                    b = '<span class="dynamiColor" style="color:' + d + '">' + b + "</span>"
                }
                if ($(c).attr("fontFamily")) {
                    var e = $(c).attr("fontFamily");
                    b = '<span class="dynamicFontFamily" style="font-family:' + e + '">' + b + "</span>"
                }
                if ($(c).attr("fontSize")) {
                    var f = $(c).attr("fontSize");
                    b = '<span class="dynamicFontSize" style="font-size:' + f + 'px">' + b + "</span>"
                }
                if ($(c).attr("backgroundColor")) {
                    var g = $(c).attr("backgroundColor");
                    b = '<span class="dynamicBackgroundColor" style="background-color:' + g + '">' + b + "</span>"
                }
                if ("superscript" == $(c).attr("baselineShift") ? b = "<sup>" + b + "</sup>" : "subscript" == $(c).attr("baselineShift") && (b = "<sub>" + b + "</sub>"), $(c).attr("fontSize") || $(c).attr("color") || $(c).attr("fontFamily")) {
                    var h = !1,
                        i = "<font";
                    $(c).attr("fontSize") && (h = !0), $(c).attr("color") && "none" != $(c).attr("breakOpportunity") && (h = !0, i += ' color="' + $(c).attr("color") + '"'), $(c).attr("fontSize") && (i += ' style=" font-size:' + $(c).attr("fontSize") + 'px"'), $(c).attr("fontFamily") && (h = !0, i += ' face="' + $(c).attr("fontFamily") + '"'), i += ">";
                    var j = "</font>";
                    h && (b = i + b + j)
                }
                "none" == $(c).attr("breakOpportunity") && (b = "<nobr>" + b + "</nobr>"), $(c).attr("styleName") && (b = '<span class="' + $(c).attr("styleName") + '">' + b + "</span>");
                break;
            case TLFToHTMLAdapter.IMG:
                var k = '<img onload="onInlineImgLoaded()" ',
                    l = " />",
                    m = "";
                $(c).attr("source") && (m += ' src="' + $(c).attr("source") + '"'), m += $(c).attr("class") ? ' class="' + $(c).attr("class") + ' inlineImage"' : ' class="inlineImage"', $(c).attr("width") && "auto" != $(c).attr("width"), $(c).attr("height") && "auto" != $(c).attr("height"), $(c).attr("alt") && (m += ' alt="' + $(c).attr("alt") + '"'), b = k + m + l;
                break;
            case TLFToHTMLAdapter.BR:
                b = "<br />";
                break;
            case TLFToHTMLAdapter.TAB:
                b = "&#09;";
                break;
            case TLFToHTMLAdapter.A:
                break;
            case TLFToHTMLAdapter.P:
                b = "<p>" + $(c).text() + "</p>"
        } else {
            var n = $(c).children();
            if (c.nodeName == TLFToHTMLAdapter.A) {
                var o = !1,
                    p = $(c).attr("href"),
                    q = "",
                    r = "";
                if ($(c).attr("id") && (r = $(c).attr("id"), o = !0, q = "glossary"), p && -1 != $(c).attr("href").indexOf("javascript") ? (o = !0, p = p.replace("javascript:tfLFlink_onClick(", "tfLFlink_onClick(event,"), p = p.replace(/"/g, "&quot;"), q = "glossary") : "" == r && (q = "referenceLink"), o) b += '<a href="javascript:;" id="' + r + '" onclick="' + p + '" target="' + $(c).attr("target") + '"';
                else {
                    var s = /^(ht|f)tp[s]?:\/\//i;
                    p && -1 != p.indexOf("mailto") ? p = p : p && !p.match(s) && (p = "http://" + p), b += '<a href="' + p + '" target="' + $(c).attr("target") + '"'
                }
                if (q && (b += ' class="' + q + '"'), o && "" == r) {
                    var t = p.substring(p.indexOf(",") + 1, p.lastIndexOf(")")),
                        u = t.split("','"),
                        v = u[u.length - 1],
                        w = v.substring(0, v.lastIndexOf("'"));
                    b += ' title="' + w.replace(/"/g, "&quot;").replace(/&/g, "&amp;").replace(/'/g, "&#39;").replace(/</g, "&lt;").replace(/>/g, "&gt;") + '"', b += ' style="white-space: nowrap"'
                } else "" != r && (b += ' title="@#@#@#@#"');
                b += ">"
            } else if (c.nodeName == TLFToHTMLAdapter.LIST) b += "decimal" == $(c).attr("listStyleType") ? $(c).attr("listStylePosition") ? '<ol style="list-style-position:' + $(c).attr("listStylePosition") + '">' : "<ol>" : $(c).attr("listStylePosition") ? '<ul style="list-style-position:' + $(c).attr("listStylePosition") + '">' : "<ul>";
            else if (c.nodeName == TLFToHTMLAdapter.LIST_ITEM) b += $(c).find("span").attr("color") ? '<li style="color:' + $(c).find("span").attr("color") + '">' : "<li>";
            else if (c.nodeName == TLFToHTMLAdapter.P || c.nodeName == TLFToHTMLAdapter.DIV) {
                var x = "";
                $(c).attr("textAlign") && (x += "text-align:" + $(c).attr("textAlign") + ";"), $(c).attr("textIndent") && (x += "text-indent:" + $(c).attr("textIndent") + "px;"), $(c).attr("paragraphStartIndent") && (x += "margin-left:" + $(c).attr("paragraphStartIndent") + "px;"), $(c).attr("paragraphEndIndent") && (x += "margin-right:" + $(c).attr("paragraphEndIndent") + "px;"), b += "" != x ? '<p style="' + x + '">' : "<p>"
            }
            switch ($(n).each(function() {
                b += TLFToHTMLAdapter.convertTagToHTMLString(this)
            }), c.nodeName == TLFToHTMLAdapter.A ? b += "</a>" : c.nodeName == TLFToHTMLAdapter.LIST ? b += "decimal" == $(c).attr("listStyleType") ? "</ol>" : "</ul>" : c.nodeName == TLFToHTMLAdapter.LIST_ITEM ? b += "</li>" : (c.nodeName == TLFToHTMLAdapter.P || c.nodeName == TLFToHTMLAdapter.DIV) && (b += "</p>"), c.nodeName) {
                case TLFToHTMLAdapter.P:
                case TLFToHTMLAdapter.DIV:
            }
        }
        return b
    }, TLFToPlainTextAdapter.TEXT_FLOW = "TextFlow", TLFToPlainTextAdapter.DIV = "div", TLFToPlainTextAdapter.P = "p", TLFToPlainTextAdapter.A = "a", TLFToPlainTextAdapter.IMG = "img", TLFToPlainTextAdapter.SPAN = "span", TLFToPlainTextAdapter.BR = "br", TLFToPlainTextAdapter.TAB = "tab", TLFToPlainTextAdapter.LIST = "list", TLFToPlainTextAdapter.LIST_ITEM = "li", TLFToPlainTextAdapter.convertToPlainText = function(a) {
        var b = "";
        if (a) {
            var c = $.parseXML(a);
            b = TLFToPlainTextAdapter.convertTagToPlainText($(c).children()[0])
        }
        return $.trim(b)
    }, TLFToPlainTextAdapter.convertTagToPlainText = function(a) {
        var b = "",
            c = a;
        if (0 == $(c).children().size()) switch (c.nodeName) {
            case TLFToPlainTextAdapter.SPAN:
                b = $(c).text();
                break;
            case TLFToPlainTextAdapter.IMG:
                $(c).attr("alt") && (b = " " + $(c).attr("alt") + " ");
                break;
            case TLFToPlainTextAdapter.TAB:
                b = " ";
                break;
            case TLFToPlainTextAdapter.A:
                b = $(c).text()
        } else {
            var d = $(c).children();
            switch ($(d).each(function() {
                b += TLFToPlainTextAdapter.convertTagToPlainText(this)
            }), c.nodeName) {
                case TLFToPlainTextAdapter.P:
                case TLFToPlainTextAdapter.DIV:
                case TLFToPlainTextAdapter.BR:
                    b.lastIndexOf(".") == b.length - 1 && (b += ". ")
            }
        }
        return b
    }, URLUtils.parseURLExtression = /^((http|ftp|https):\/)?\/?([^\/\s]+)((\/[\w\-]+)*\/)([\w\-\.]+\.[^#?\s]+)(#[\w\-]+)?$/, URLUtils.extractProtocol = function(a) {
        var b = "";
        return a.match(URLUtils.parseURLExtression) && (b = RegExp.$2), b
    }, URLUtils.extractHost = function(a) {
        var b = "";
        return a.match(URLUtils.parseURLExtression) && (b = RegExp.$3), b
    }, URLUtils.extractPath = function(a) {
        var b = "";
        return a.match(URLUtils.parseURLExtression) && (b = RegExp.$4), b
    }, URLUtils.extractFileName = function(a) {
        var b = "";
        return a.match(URLUtils.parseURLExtression) && (b = RegExp.$6), b
    }, mediaImage.zoomThreshold = 99, mediaImage.createElement = function(a, b) {
        if (b = void 0 == b || null == b ? !0 : b, 0 == $("#imgHolder").size() && $("body").append('<div id="imgHolder" />'), a) {
            var c = $("<div class='mediaWrapper' />"),
                d = $("<div class='imageDataGroup' />"),
                e = $("<p class='imageParent' />"),
                f = $("<img class='imageElement' />"),
                g = $("<p class='caption'/>"),
                h = $("<p class='addInstruction'/>");
            if ($(e).append(h), $(e).append(f), $(d).append(e), $(d).append(g), $(c).append(d), $(f).bind("load", function() {
                    a.width || a.height || a.perWidth || a.perHeight ? ($(window).bind("resize", function() {
                        if (a.width && ($(c).css("max-width", "none"), $(c).css("max-height", "none"), $(d).css("max-width", "none"), $(f).css("max-width", "none"), $(f).css("max-height", "none"), $(f).css("width", Number(a.width)), $(c).css("width", Number(a.width) + 12)), a.height && $(f).css("height", Number(a.height)), a.perWidth) {
                            $(c).css("max-width", "none"), $(c).css("max-height", "none"), $(d).css("max-width", "none"), $(f).css("max-width", "none"), $(f).css("max-height", "none"); {
                                Number(a.perWidth)
                            }
                        }
                        a.perHeight, b && addZoom(f), refreshPage();
                        try {
                            updateContainer()
                        } catch (e) {}
                    }), b && addZoom(f), refreshPage()) : (setMaxImageWidthFor(f), $(f).data("currentWidth", $(f).width()), $(window).bind("resize refresh", function() {
                        setMaxImageWidthFor(f);
                        var a = getImageWidth(f);
                        $(f).data("currentWidth", a), b && addZoom(f);
                        try {
                            updateContainer()
                        } catch (c) {}
                    }), imageWidth = getImageWidth(f), $(f).data("currentWidth", imageWidth), b && addZoom(f), refreshPage())
                }), a.width && ($(c).css("max-width", "none"), $(c).css("max-height", "none"), $(d).css("max-width", "none"), $(f).css("max-width", "none"), $(f).css("max-height", "none"), $(f).css("width", Number(a.width)), $(c).css("width", Number(a.width) + 12)), a.height && $(f).css("height", Number(a.height)), a.perWidth) {
                $(c).css("max-width", "none"), $(c).css("max-height", "none"), $(d).css("max-width", "none"), $(f).css("max-width", "none"), $(f).css("max-height", "none");
                var i = Number(a.perWidth);
                $(f).css("width", "100%"), dataObject.templateIdentifier ? 0 == dataObject.templateIdentifier.indexOf("TS_") && $(c).css("width", i + "%") : $(c).css("width", i - 3 + "%")
            }
            a.perHeight, a.alternateText && $(f).attr("alt", a.alternateText), a.urls["default"] && ("media partial" == a.addclass ? ($(h).append(a.add), $(f).remove()) : ($(f).attr("src", a.urls["default"]), $(h).remove())), a.caption && "" != a.caption ? $(g).html(a.caption) : $(g).remove();
            var j = null;
            j = $(f).clone(), j.removeAttr("height"), j.removeAttr("width"), j.removeAttr("class"), j.removeAttr("style"), j.removeAttr("id"), $("#imgHolder").append(j), $(j).bind("load", function() {
                $(f).data("actualWidth", $(j).width()), (a.width || a.height || a.perWidth || a.perHeight) && $(f).data("maxPossibleWidth", $(f).width()), b && addZoom(f), $(this).remove()
            })
        }
        return $(c)
    }, mediaImage.setTabIndices = function(a, b) {
        return $(a).find(".imageElement").attr("tabindex", b++), $(a).find(".caption").attr("tabindex", b++), b++, b++
    };
var title;
$.fn.removeDefaultTip = function() {
    $(this).hover(function(a) {
        a.preventDefault(), title = $(this).attr("title"), $(this).attr("title", "")
    }, function(a) {
        a.preventDefault(), $(this).attr("title", title)
    })
}, Array.prototype.shuffle = function() {
    for (var a = 0; a < this.length; a++) {
        var b = this[a],
            c = Math.floor(Math.random() * this.length);
        this[a] = this[c], this[c] = b
    }
}, shuffle = function(a) {
    for (var b, c, d = a.length; d; b = parseInt(Math.random() * d), c = a[--d], a[d] = a[b], a[b] = c);
    return a
}, Swipe.MIN_LENGTH = 72, Swipe.DIRECTION = {
    LEFT: 0,
    RIGHT: 1,
    UP: 2,
    DOWN: 3
}, Swipe.prototype.reset = function() {
    this.startX = 0, this.startY = 0, this.curX = 0, this.curY = 0
}, Swipe.prototype.getSwipeLength = function() {
    var a = this.curX - this.startX,
        b = this.curY - this.startY;
    return Math.round(Math.sqrt(Math.pow(a, 2) + Math.pow(b, 2)))
}, Swipe.prototype.getSwipeAngle = function() {
    var a = this.startX - this.curX,
        b = this.curY - this.startY;
    return Math.atan2(b, a)
}, Swipe.prototype.getSwipeDirection = function(a) {
    return swipeDirection = a >= -Math.PI / 4 && a <= Math.PI / 4 ? Swipe.DIRECTION.LEFT : a >= Math.PI / 4 && a <= 3 * Math.PI / 4 ? Swipe.DIRECTION.DOWN : a < -Math.PI / 4 && a >= -3 * Math.PI / 4 ? Swipe.DIRECTION.UP : Swipe.DIRECTION.RIGHT
}, Swipe.prototype.dispatchEvent = function(a) {
    switch (a) {
        case Swipe.DIRECTION.LEFT:
            this.onLeft();
            break;
        case Swipe.DIRECTION.RIGHT:
            this.onRight();
            break;
        case Swipe.DIRECTION.UP:
            this.onUp();
            break;
        case Swipe.DIRECTION.DOWN:
            this.onDown()
    }
};