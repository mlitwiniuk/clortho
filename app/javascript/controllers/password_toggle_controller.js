/* jshint esversion: 6 */

import {
  Controller
} from "stimulus"

export default class extends Controller {
  static targets = ["trigger", "input"]

  connect() {
  }

  togglePassword() {
    this.inputTarget.type = this.inputTarget.type == 'text' ? 'password' : 'text';
  }

}
