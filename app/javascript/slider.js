
// TODO: http://idangero.us/swiper/api/#custom-build
// lazy load

import Swiper from 'swiper/dist/js/swiper.js';

var ready;

ready = void 0;

ready = function() {
  var thumbsProperties = {
        watchSlidesVisibility: true,
        watchSlidesProgress: true,
        slideToClickedSlide: true,
        // slidesPerColumn: 2,
        // slidesPerColumnFill: 'row',
        slidesPerView: 4,
        observer: true,
        observeParents: true,
        observeSlideChildren: true,
        preventClicks: false,
        preventClicksPropagation: false,
        updateOnImagesReady: true,
        preloadImages: true
        // spaceBetween: 5
  };
  var galleryThumbs = new Swiper('.gallery-thumbs', thumbsProperties);

  var topProperties = {
        watchSlidesVisibility: true,
        watchSlidesProgress: true,
        simulateTouch: false,
        navigation: {
          nextEl: '.swiper-button-next',
          prevEl: '.swiper-button-prev',
        },
        thumbs: {
          swiper: galleryThumbs
       },
       observer: true,
       observeParents: true,
       observeSlideChildren: true,
       preventClicks: false,
       preventClicksPropagation: false,
       updateOnImagesReady: true,
       preloadImages: true
     };
      var galleryTop = new Swiper('.gallery-top', topProperties);
      $( "#btnPhotos" ).on("click", function(e) {
       if ($( ".gallery-top" ).hasClass('current3DView')) {
         $( ".gallery-top" ).removeClass('current3DView').addClass('currentPhotos');
         var galleryTop = document.querySelector('.gallery-top').swiper;
         var galleryThumbs = document.querySelector('.gallery-thumbs').swiper;
         galleryThumbs.removeAllSlides();
         galleryTop.removeAllSlides();
         galleryThumbs.destroy();
         galleryTop.destroy();
         // thumbsProperties.slidesPerColumn = 1;
         // $(".swiper-slide").not("[data-filter=image]").addClass("non-swiper-slide").removeClass("swiper-slide").hide();
         // $("[data-filter=image]").removeClass("non-swiper-slide").addClass("swiper-slide").show();

         var galleryThumbs = new Swiper('.gallery-thumbs', thumbsProperties);
         var content = '';
         content += '<div class="swiper-slide"><img src="http://placehold.it/125x75&text=1"/></div>';
         content += '<div class="swiper-slide"><img src="http://placehold.it/125x75&text=2"/></div>';
         content += '<div class="swiper-slide"><img src="http://placehold.it/125x75&text=3"/></div>';

         galleryThumbs.appendSlide(content);
         galleryThumbs.update();

         topProperties.thumbs.swiper = galleryThumbs;
         var galleryTop = new Swiper('.gallery-top', topProperties);
         var content = '';
         content += '<div class="swiper-slide"><img src="http://placehold.it/500x400&text=1 slider"/></div>';
         content += '<div class="swiper-slide"><img src="http://placehold.it/500x400&text=2 slider"/></div>';
         content += '<div class="swiper-slide"><img src="http://placehold.it/500x400&text=3 slider"/></div>';

         galleryTop.appendSlide(content);
         galleryTop.update();

         galleryTop.slideTo(0);
         galleryThumbs.slideTo(0);
       }
      });
      $( "#btn3DView" ).click(function(e) {
       if ($( ".gallery-top" ).hasClass('currentPhotos')) {
         $( ".gallery-top" ).removeClass('currentPhotos').addClass('current3DView');
         var galleryTop = document.querySelector('.gallery-top').swiper;
         var galleryThumbs = document.querySelector('.gallery-thumbs').swiper;
         galleryThumbs.removeAllSlides();
         galleryTop.removeAllSlides();
         galleryThumbs.destroy();
         galleryTop.destroy();
         // thumbsProperties.slidesPerColumn = 1;
         // $(".swiper-slide").not("[data-filter=model]").addClass("non-swiper-slide").removeClass("swiper-slide").hide();
         // $("[data-filter=model]").removeClass("non-swiper-slide").addClass("swiper-slide").show();

         var galleryThumbs = new Swiper('.gallery-thumbs', thumbsProperties);
         var content = '';
         content += '<div class="swiper-slide"><img src="http://placehold.it/125x75/0ebbe4/000000&text=3D Görünüm 1"/></div>';
         content += '<div class="swiper-slide"><img src="http://placehold.it/125x75/0ebbe4/000000&text=3D Görünüm 2"/></div>';

         galleryThumbs.appendSlide(content);
         galleryThumbs.update();

         topProperties.thumbs.swiper = galleryThumbs;

         var galleryTop = new Swiper('.gallery-top', topProperties);
         var content = '';
         content += '<div class="swiper-slide"><stl-part-viewer src= "https://boyutluseyler-staging.s3.eu-central-1.amazonaws.com/bowser_low_poly_flowalistik2.STL"></stl></div>';
         content += '<div class="swiper-slide"><stl-part-viewer src= "https://boyutluseyler-staging.s3.eu-central-1.amazonaws.com/bowser_low_poly_flowalistik2.STL"></stl></div>';

         galleryTop.appendSlide(content);
         galleryTop.update();

         galleryTop.slideTo(0);
         galleryThumbs.slideTo(0);
       }

      });

      $( ".gallery-top" ).addClass('current3DView');
      $( "#btnPhotos" ).trigger( "click" );
};

$(document).ready(ready);

$(document).on('turbolinks:load', ready);
