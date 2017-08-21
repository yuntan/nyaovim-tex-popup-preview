(function(){
  'use strict';

  let popup, proj;

  Polymer({
    is: 'tex-popup-preview',

    properties: {
      color: {
        type: String,
        value: ''
      },
      shown: {
        type: Boolean,
        value: false
      },
      x: {
        type: Number,
        value: 0
      },
      y: {
        type: Number,
        value: 0
      },
      editor: Object,
    },

    ready: function() { // use function instead of arrow for this
      popup = document.querySelector('tex-popup-preview .popup')
      proj = document.querySelector('tex-popup-preview .proj')
      // popup = document.getElementById('popup');
      // proj = document.getElementById('proj');
      if (this.color) {
        popup.style.backgroundColor = this.color;
        proj.style.backgroundColor = this.color;
      }
      if (this.shown) {
        this.show(this.x, this.y);
      }
      this.client = this.editor.getClient();
      this.client.on('notification', this.onNotification.bind(this));
      this.client.subscribe('tex-popup-preview:toggle');
      this.client.subscribe('tex-popup-preview:open');
      this.client.subscribe('tex-popup-preview:close');
    },

    onNotification: function(method, args) {
      switch (method) {
        case 'tex-popup-preview:close':
          if (this.shown) {
            this.dismiss();
          }
          break;
        case 'tex-popup-preview:open':
          if (!this.shown) {
            this.show(...args);
          }
          break;
        case 'tex-popup-preview:toggle':
          if (this.shown) {
            this.dismiss();
          } else {
            this.show(...args);
          }
          break;
      }
    },

    setContent: function(tex) {
      //let elem = popup.childNodes[0];
      let elem = popup;
      let displayMode = true;
      katex.render(tex, elem, {displayMode, throwOnError: false});
      // module.exports.render(tex, elem, {displayMode, throwOnError: false});
    },

    show: function(tex, line, col) {
      this.setContent(tex);

      var loc = this.editor.screen.convertPositionToLocation(line, col - 1);

      const {line_, col_} = this.editor.store.cursor;
      const {width, height} = this.editor.store.font_attr;
      const x = col_ * width;
      const y = line_ * height;

      popup.style.left = (loc.x - 20 - 13) + 'px';
      popup.style.top = (loc.y + 13) + 'px';
      popup.style.display = 'block';
      proj.style.left = (loc.x - 13) + 'px';
      proj.style.top = loc.y + 'px';
      proj.style.display = 'inline'

      this.shown = true;
    },

    dismiss: function() {
      popup.style.display = 'none';
      proj.style.display = 'none'
      this.shown = false;
    },

    toggle: function(x, y) {
      if (this.shown) {
        this.dismiss();
      } else {
        this.show(x, y);
      }
    },
  });
})();
