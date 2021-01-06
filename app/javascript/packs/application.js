// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "channels"

Rails.start()
Turbolinks.start()

import "controllers"
// import 'bootstrap/dist/js/bootstrap'
import 'bootstrap/dist/js/bootstrap.esm'
// import 'bootstrap/dist/css/bootstrap'
import '@tabler/core/dist/css/tabler.css'
require("css/application.scss")
import "@fortawesome/fontawesome-free/js/all"
