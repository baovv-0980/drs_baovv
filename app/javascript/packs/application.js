import "bootstrap"
import "../stylesheets/application"
import "@fortawesome/fontawesome-free/js/all";
import 'inputmask';

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

require("packs/demo")
require("packs/adminlte")

jQuery(function($){
   $("#date").mask("99/99/9999");
});
