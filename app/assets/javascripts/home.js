//= require ./home/hammer.min.js
//= require ./home/jquery.superslides.min.js
//= require ./home/jquery.tinyMap.js
//= require_directory ./home/CollagePlus
//= require ./home/jquery.colorbox-min.js

// jQuery to collapse the navbar on scroll
		$(window).scroll(function() {
			if ($(".navbar").offset().top > 50) {
				$(".navbar-fixed-top").addClass("top-nav-collapse");
				console.log("YOSH");
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
                play: 7000 // 7s per slide
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