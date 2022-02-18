
angular.module('mobileKeyboard-holder').controller('MobileKeyboardCtrl', function MobileKeyboardCtrl($state, $scope, $timeout) {
    $scope.mobileKeyboardData = mobileKeyboardData;

    $timeout(function() {
    	$('.number').on('touchstart click',$scope.onNumberBtnClick);
    	$('.mathPanel').on('touchstart click',$scope.onMathBtnClick);
    	$('.relativeDiv').on('touchstart click',$scope.onArrowClick);
    	$('.chooseDiv').on('touchstart click',$scope.onChooseClick);
    	$('.overlay-modal').on('touchstart click',$scope.onOverlayClick)

    	$('.equation-holder').on('touchstart click',$scope.onMathquillTap);
    	$('.keys').on('touchstart click',$scope.onKeyTap);
        
		
		var containmentBottom = $('body').height() - $(".mobile-keyboard").height() - $('.equation-holder').height();

		// $('#bar').draggable({axis: 'y', containment : [0,0,0,containmentBottom] });

		answerMathField.focus();

    	$('.equation-holder').draggable({ 
    		handle: ".drag-this",
    		scroll : false,
    		containment : [0,0,$('body').width() - $('.equation-holder').width(),containmentBottom]
     	});

     	$('.done-btn').on('touchstart click',$scope.onDoneBtnClick);

     	$('.txt-abc').on('touchstart click',$scope.onAbcBtnClick);
		$('.enterclick').on('touchstart click', $scope.onenterbuttonclick);

     	$(window).on('resize', function(event) {
     		$('.math-holder').css('margin-top', '0px');

     		var containmentBottom = $('body').height() - $(".mobile-keyboard").height() - $('.equation-holder').height();

			$('.equation-holder').draggable({ 
	    		handle: ".drag-this",
	    		scroll : false,
	    		containment : [0,0,$('body').width() - $('.equation-holder').width(),containmentBottom]
	     	});
	     	$('.equation-holder').css({'top':'0px','left':'0px'});
	    });
    });

    $scope.onNumberBtnClick = function() {
    	$('.math').hide();
    	$('.numberPanel').show();
    };

    $scope.onMathBtnClick = function() {
    	$('.math').show();
    	$('.numberPanel').hide();
    };

    $scope.onArrowClick = function() {
    	if($('.overlay-modal').css('display') == 'none') {
    		if($('.numberPanel').css('display') == 'none') {
    			$('.navPanel').css('left','58.5%');
    		}
    		else
    		{
    			$('.navPanel').css('left','60.5%');
    		}
	    	$('.overlay-modal').show();
    		$('.navPanel').show();
    		$('.relativeDiv').css('position','relative');
    	}
    	else
    	{
    		$('.overlay-modal').hide();
    		$('.navPanel').hide();
    		$('.relativeDiv').css('position','static');
    	}
    };

    $scope.onChooseClick = function() {
    	if($('.overlay-modal').css('display') == 'none') {
	    	$('.overlay-modal').show();
    		$('.choosePanel').show();
    		$('.chooseDiv').css('position','relative');
    	}
    	else
    	{
    		$('.overlay-modal').hide();
    		$('.choosePanel').hide();
    		$('.chooseDiv').css('position','static');
    	}
    };

    $scope.onOverlayClick = function() {
		$('.overlay-modal').hide();
		$('.choosePanel').hide();
		$('.chooseDiv').css('position','static');
		$('.navPanel').hide();
    	$('.relativeDiv').css('position','static');
    };

    $scope.onMathquillTap = function(event) {
    	answerMathField.focus();
    };

    $scope.onKeyTap = function(event) {
    	event.preventDefault();
    	var arrDataLatex = $(event.currentTarget).attr('data-latex-val').split('-'),
    		split1 = arrDataLatex[0],
    		split2 = arrDataLatex[1],
    		split3 = arrDataLatex[2],
    		latex = mobileKeyboardData[split1][split2][Number(split3)-1].latex
    		// spec = mobileKeyboardData[split1][split2][Number(split3)-1].spec,
    		// keyCodeData = mobileKeyboardData[split1][split2][Number(split3)-1].keyCodes;

    	if(latex !== undefined) {
    		$.each(latex , function(index,obj){
    			if(obj.indexOf('key') >= 0)
    			{
    				answerMathField.keystroke(obj.slice(obj.indexOf('-') + 1,obj.length));
    			}
    			else
    			{
    				answerMathField.typedText(obj);
    			}
    		});
    		answerMathField.focus();
    	}


    };
	
	 $scope.onenterbuttonclick = function () {
        window.enterPress();
    }

    $scope.onDoneBtnClick = function(event) {
    	var metaString = {
			'latex' : answerMathField.latex(),
			'height' : $(answerSpan).height(),
			'width' : $(answerSpan).width(),
			'fontSize' : $(answerSpan).css('font-size')
		};

		var encodedString = encodeURIComponent(JSON.stringify(metaString));
		$scope.nativeCallback(encodedString);		
    };

    $scope.onAbcBtnClick = function(event) {
    	var metaString = {
			'changeKeyboard' : true,
			'latex' : answerMathField.latex()
		};

		var encodedString = encodeURIComponent(JSON.stringify(metaString));
		$scope.nativeCallback(encodedString);	
    }

    $scope.nativeCallback = function(encodedString) {
		var userAgent = window.navigator.userAgent;

		if(userAgent.indexOf('Android') !== -1)
	    {
	      window.android.getEquationData(encodedString);
	    }
	    else if((userAgent.indexOf('iPad')!==-1 || userAgent.indexOf('iPhone')!==-1 | ((navigator.platform === 'MacIntel') && (navigator.maxTouchPoints > 1))))
	    {
	      window.location ="getEquationData:"+encodedString;
	    }
	    else {
	      // if(window.external.notify)
	      // {
	        window.external.notify(encodedString);
	      // }
	    }
	};

});
