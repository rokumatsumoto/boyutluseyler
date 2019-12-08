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

import "core-js/stable";

import "regenerator-runtime/runtime";

import Rails from 'rails-ujs';

Rails.start();

import * as ActiveStorage from 'activestorage';

ActiveStorage.start();

import Turbolinks from 'turbolinks';

Turbolinks.start();

import LocalTime from 'local-time';

LocalTime.start();

import 'bootstrap/dist/js/bootstrap';

import 'lib/pagy.js.erb';

// https://github.com/DavyJonesLocker/client_side_validations/issues/767
require('@client-side-validations/client-side-validations')
require('@client-side-validations/simple-form/dist/simple-form.bootstrap4')
require('argon');
