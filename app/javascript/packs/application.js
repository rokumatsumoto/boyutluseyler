/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// https://github.com/rails/webpacker/blob/master/docs/assets.md
import '../styles';

import Rails from 'rails-ujs';
import * as ActiveStorage from 'activestorage';
import Turbolinks from 'turbolinks';
import LocalTime from 'local-time';
import 'bootstrap/dist/js/bootstrap';

Rails.start();
ActiveStorage.start();
Turbolinks.start();
LocalTime.start();

require('rails.validations');
require('rails.validations.simple_form.bootstrap4');
