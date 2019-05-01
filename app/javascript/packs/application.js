/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)






// https://github.com/rails/webpacker/blob/master/docs/assets.md
import '../styles';

import Rails from 'rails-ujs';
Rails.start();
import * as ActiveStorage from 'activestorage';
ActiveStorage.start();
import Turbolinks from 'turbolinks';
Turbolinks.start();
import 'bootstrap/dist/js/bootstrap';
require('../lib/rails.validations');
require('../lib/rails.validations.simple_form.bootstrap4');
import LocalTime from 'local-time';
LocalTime.start();
require('../username_validator');
require('../user_profile');

import 'intersection-observer/intersection-observer';
import '@justinribeiro/stl-part-viewer';

// import 'slick-carousel';
import Swiper from 'swiper';

document.addEventListener("turbolinks:load", () => {
  $(function() {
      $( "#btnPhotos" ).trigger( "click" );
  });
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
         preventClicksPropagation: false
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
        preventClicksPropagation: false
      };
       var galleryTop = new Swiper('.gallery-top', topProperties);

       $( "#btnPhotos" ).on("click", function(e) {
        var galleryTop = document.querySelector('.gallery-top').swiper;
        var galleryThumbs = document.querySelector('.gallery-thumbs').swiper;
        galleryThumbs.destroy();
        galleryTop.destroy();
        // thumbsProperties.slidesPerColumn = 1;
        $(".swiper-slide").not("[data-filter=image]").addClass("non-swiper-slide").removeClass("swiper-slide").hide();
        $("[data-filter=image]").removeClass("non-swiper-slide").addClass("swiper-slide").show();
        var galleryThumbs = new Swiper('.gallery-thumbs', thumbsProperties);
        galleryThumbs.update();
        topProperties.thumbs.swiper = galleryThumbs;
        var galleryTop = new Swiper('.gallery-top', topProperties);
        galleryTop.update();

        // galleryTop.slideTo(0);
        // galleryThumbs.slideTo(0);
       });
       $( "#btn3DView" ).click(function(e) {
        var galleryTop = document.querySelector('.gallery-top').swiper;
        var galleryThumbs = document.querySelector('.gallery-thumbs').swiper;
        galleryThumbs.destroy();
        galleryTop.destroy();
        // thumbsProperties.slidesPerColumn = 1;
        $(".swiper-slide").not("[data-filter=model]").addClass("non-swiper-slide").removeClass("swiper-slide").hide();
        $("[data-filter=model]").removeClass("non-swiper-slide").addClass("swiper-slide").show();

        var galleryThumbs = new Swiper('.gallery-thumbs', thumbsProperties);
        galleryThumbs.update();
        topProperties.thumbs.swiper = galleryThumbs;
        // galleryThumbs.on('click', function (e) {
        //   console.log(this.clickedIndex);
        // });
        var galleryTop = new Swiper('.gallery-top', topProperties);
        galleryTop.update();
        console.log('hi');



        // debugger;
        // galleryTop.slideTo(3);
        // galleryThumbs.slideTo(3);
       });

});



