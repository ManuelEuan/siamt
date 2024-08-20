import Vue from 'vue'

/**
 * Copy to clipboard the text passed
 * @param {String} text string to copy
 * @param {String} toastText message to appear on the toast notification
 */

const cssText = 'position:fixed; pointer-events:none; z-index:-9999; opacity:0;'

const createTextarea = (value) => {
  const textarea = document.createElement('textarea')

  textarea.addEventListener('focusin', (event) => {
    event.stopPropagation()
  })

  textarea.value = value
  textarea.setAttribute('readonly', '')
  textarea.style.cssText = cssText
  console.log(textarea.value);
  return textarea
}

const Clipboard = {
  /**
   * Requests Navigator API persmission to clipboard.
   */
  async requestClipboardPermission() {
    return navigator.permissions.query({
      name: 'clipboard-write'
    })
  },
  /**
   * Writes to cliboard using Navigator API.
   */
  async writeClipboard(value) {
    const permissions = await Clipboard.requestClipboardPermission()

    if (permissions.state === 'granted') {
      await navigator.clipboard.writeText(value)
      return true
    }

    return false
  },
  /**
   * Writes to clipboard using old-school execCommand('copy').
   */
  writeClipboardExecCommand(value) {
    const textarea = createTextarea(value)

    document.body.appendChild(textarea)

    if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
      textarea.contentEditable = 'true'
      textarea.readOnly = true

      const range = document.createRange()

      range.selectNodeContents(textarea)

      const selection = window.getSelection()

      if (selection) {
        selection.removeAllRanges()
        selection.addRange(range)
        textarea.setSelectionRange(0, 999999)
      }
    } else {
      textarea.select()
    }

    const result = document.execCommand('copy')
    document.body.removeChild(textarea)

    return result
  },
  /**
   * Maes an attempt to copy data to the clipboard.
   */
  async copy(input) {
    const data = typeof input === 'function' ? input() : input;
    const value = data; //Convert.asString(data)

    const copied = Clipboard.writeClipboardExecCommand(value);
    if (copied) {
      return true;
    }

    return await Clipboard.writeClipboard(value);
  }
}

Vue.prototype.$clipboard = function (text, toastText = 'Copied to clipboard!') {
  
  // const el = document.createElement('textarea')
  // el.value = text
  // document.body.appendChild(el)
  // el.select()
  // document.execCommand('copy')
  // document.body.removeChild(el)
  const copied = Clipboard.copy(text);
  if (this.$store && this.$store.dispatch) this.$store.dispatch('app/showToast', toastText);

  return copied;
}