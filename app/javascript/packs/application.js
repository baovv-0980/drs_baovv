import "bootstrap"
import "../stylesheets/application"
import "@fortawesome/fontawesome-free/js/all";
import 'inputmask';
import "../stylesheets/application"

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

require("packs/demo")
require("packs/adminlte")
require("toastr")

import toastr from 'toastr';

toastr.options = {
  // thay đổi nội dung hiển thị trên nút close, vd như "Đóng"
  "closeButton": false,

  // thay đổi vị trí của notification
  "positionClass": "toast-top-center",

  // Các thông báo có hiển thị cùng 1 lúc hay khi cái sau xuất hiện sẽ ẩn cái trước
  "preventDuplicates": false,

  // action khi click vào thông báo
  "onclick": null,

  // thời gian, hiệu ứng hiển thị và ẩn
  "showDuration": "300",
  "hideDuration": "1000",
  "timeOut": "5000",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}
global.toastr = toastr;
