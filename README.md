nyaovim-tex-popup-preview
=========================
[![https://gyazo.com/042a7f5902dff0ce0d09bca79969c14c](https://i.gyazo.com/042a7f5902dff0ce0d09bca79969c14c.png)](https://gyazo.com/042a7f5902dff0ce0d09bca79969c14c)

INSTALL
-------
init.vim:

```vim
Plug 'yuntan/nyaovim-tex-popup-preview'

nmap gt <Plug>(nyaovim-tex-popup-preview-open)
```

nyaovimrc.html:

```html
<dom-module id="nyaovim-app">
  <template>
    <style>
    </style>

    <neovim-editor></neovim-editor>
    <tex-popup-preview editor="[[editor]]"></tex-popup-preview>
  </template>
</dom-module>
```
