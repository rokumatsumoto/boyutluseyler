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

     var swiper = new Swiper('.swiper-container', {
       centeredSlides: false,
       simulateTouch: false,
       navigation: {
         nextEl: '.swiper-button-next',
         prevEl: '.swiper-button-prev',
       }
     });
     $( ".photos" ).click(function(e) {
          e.preventDefault();
          e.stopPropagation();
          swiper.slideTo(0, 3);
     });
     $( ".3D-view" ).click(function(e) {
          e.preventDefault();
          e.stopPropagation();
          swiper.slideTo(3, 5);
     });
     // document.querySelector('.3D-view').addEventListener('click', function (e) {

     // });
     // document.querySelector('.photos').addEventListener('click', function (e) {

     // });

  // $('.portfolio-item-slider').on('init', function(event, slick, currentSlide){
  //   var nrCurrentSlide = slick.currentSlide + 1, // din cauza ca e array si incepe de la 0
  //       totalSlidesPerPage = nrCurrentSlide + 3; // daca ai 5 thumb-uri pe pagina pui + 4
  //   // $('.controls').html(nrCurrentSlide + " - " + totalSlidesPerPage + " of " + slick.slideCount);

  // });


  // $('#btnPhotos, #btn3DView').on('click',filterSlider);

  // function filterSlider(e){

  //   var $slider = $('.portfolio-item-slider, .portfolio-thumb-slider');
  //   var clickedBtnId = $(e.currentTarget).attr('id');

  //   $slider.each(function(){
  //     var $slick = $(this);
  //     unfilterSlick($slick);

  //     var $slide = $slick.find('.slick-slide');
  //     var filter = (clickedBtnId == 'btnPhotos') ? $slide.slice(0,6) : $slide.slice(6,7);
  //     filterSlick($slick,filter);
  //   });

  // }

  // function unfilterSlick($slick){
  //   $slick.slick('slickUnfilter');
  // }

  // function filterSlick($slick,filter){
  //   $slick.slick('slickFilter',filter);
  //   reIndexSlide($slick);
  // }

  // function reIndexSlide($slick){
  //   var $slides = $slick.find('.slick-active');
  //   $slides.each(function(index, slide) {
  //     $(slide).attr('data-slick-index', index);
  //   });
  //   $slick.slick('slickGoTo',0,true);
  //   var $slider = $('.portfolio-item-slider, .portfolio-thumb-slider');
  // }

  // $( "#btnPhotos, #btn3DView" ).click(function() {
  //   if (!$(this).hasClass('current')) {

  //     var filterName = undefined;
  //     if (this.id == 'btnPhotos'){
  //       filterName = '.photos';
  //       $(this).addClass('current');
  //       $('#btn3DView').removeClass('current');
  //     } else {
  //       filterName = '.3DView';
  //       $(this).addClass('current');
  //       $('#btnPhotos').removeClass('current');
  //     }
  //     // $('.portfolio-item-slider, .portfolio-thumb-slider').slick('slickUnfilter');
  //     $('.portfolio-item-slider, .portfolio-thumb-slider').slick('slickFilter', $(filterName).parent().parent()).slick('refresh');
  //     $('.portfolio-item-slider, .portfolio-thumb-slider').slick('slickGoTo', 0);
  //   };
  // });
  //


  // $('.portfolio-item-slider').slick({
  //   slidesToShow: 1,
  //   slidesToScroll: 1,
  //   asNavFor: '.portfolio-thumb-slider',
  //   infinite: false,
  //   draggable: false,
  //   arrows: false
  // });

  // $('.portfolio-thumb-slider').slick({
  //   slidesToShow: 4,
  //   slidesToScroll: 1,
  //   asNavFor: '.portfolio-item-slider',
  //   arrows: true,
  //   focusOnSelect: true,
  //   infinite: false
  // });

  // var current = 0; // current slider dupa refresh
  // $('.portfolio-thumb-slider .slick-slide:not(.slick-cloned)').eq(current).addClass('slick-current');
  // $('.portfolio-item-slider').on('afterChange', function(event, slick, currentSlide, nextSlide){
  //   current = currentSlide;
  //   $('.portfolio-thumb-slider .slick-slide').removeClass('slick-current');
  //   $('.portfolio-thumb-slider .slick-slide:not(.slick-cloned)').eq(current).addClass('slick-current');
  //   var nrCurrentSlide = slick.currentSlide + 1, // din cauza ca e array si incepe de la 0
  //       totalSlidesPerPage = nrCurrentSlide + 3; // daca ai 5 thumb-uri pe pagina pui + 4

  //   if(totalSlidesPerPage > slick.slideCount) {
  //     // $('.controls').html(nrCurrentSlide + " - " + slick.slideCount + " of " + slick.slideCount);
  //   } else {
  //     // $('.controls').html(nrCurrentSlide + " - " + totalSlidesPerPage + " of " + slick.slideCount);
  //   }
  // });
});



