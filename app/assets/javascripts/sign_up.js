$(function() {
  //__________________slider___________________________________________
	// var pos = 0;
	// var currentMargin = 0;

	// $("#js-slider-btn-right").click(function() {
	//   if (pos < 2) {
	//     for (i = 1; i <= 3; i++)
	//       $(".dot" + i).removeClass("active");
	//     pos++;
	//     $(".dot" + (pos+1)).addClass("active");
	//     currentMargin += -330;
	//     $(".js_slider_frame").css("margin-left", currentMargin + "px");
	//   }
	// });

	// $("#js-slider-btn-left").click(function() {
	//   if (pos > 0) {
	//     for (i = 1; i <= 3; i++)
	//       $(".dot" + i).removeClass("active");
	//     pos--;
	//     $(".dot" + (pos+1)).addClass("active");
	//     currentMargin += 330;
	//     $(".js_slider_frame").css("margin-left", currentMargin + "px");
	//   }
	// });
  //__________________submit button disabled unless Conditions Checked_
  var chkbox = $("#user_terms_of_service");
	sign_up_button = $("#sign_up_btn_js_slider");
	sign_up_button.attr("disabled","disabled");
	chkbox.change(function(){
	    if(this.checked){
        sign_up_button.removeAttr("disabled");
      }else{
        sign_up_button.attr("disabled","disabled");
      }
  });
	//_________________key controls_____________
	// $(document).keydown(function(e) {
	//    switch (e.which) {
	//      case 37:
	//        // left
	//        // console.log("left");
	//        if (pos > 0) {
	//          for (i = 1; i <= 3; i++)
	//            $(".dot" + i).removeClass("active");
	//          pos--;
	//          $(".dot" + (pos+1)).addClass("active");
	//          currentMargin += 330;
	//          $(".js_slider_frame").css("margin-left", currentMargin + "px");
	//        }
	//        break;
	//      case 39:
	//        // right
	//        // console.log("right");
	//        if (pos < 2) {
	//          for (i = 1; i <= 3; i++)
	//            $(".dot" + i).removeClass("active");
	//          pos++;
	//          $(".dot" + (pos+1)).addClass("active");
	//          currentMargin += -330;
	//          $(".js_slider_frame").css("margin-left", currentMargin + "px");
	//        }
	//        break;
	//      // case 38:
	//      //   // up
	//      //   break;
	//      // case 40:
	//      //   // down
	//      //   break;
	//      default:
	//        return;
	//    }
	//    e.preventDefault();
	// });
});
	

