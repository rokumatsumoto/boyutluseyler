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

// require('../slider');



