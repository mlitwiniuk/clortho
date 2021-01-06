/* jshint esversion: 6 */

import {
  Controller
} from "stimulus"

export default class extends Controller {
  static targets = ["trigger", "toggled"]

  connect() {
    this.checkVisibility()
  }

  toggleVisibility() {
    this.toggledTarget.dataset.visible = !(this.toggledTarget.dataset.visible === 'true');
    this.checkVisibility()
  }

  checkVisibility() {
    let s = "display: none !important;"
    if (this.toggledTarget.dataset.visible === 'true') {
      s = "display: inherit;"
    }
    this.toggledTarget.style = s;
  }
}
