// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "jquery"
import "@nathanvda/cocoon"

global.jQuery, global.$ = require("jquery");

require("../utilities/edit_answer")
require("../utilities/edit_question")
require("../utilities/votes")

Rails.start()
Turbolinks.start()
ActiveStorage.start()
