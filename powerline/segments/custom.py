from __future__ import unicode_literals, absolute_import, division

import os
import vim

from powerline.bindings.vim import vim_get_func

# from powerline.bindings.vim import (vim_get_func, getbufvar, vim_getbufoption,
#                                                                         buffer_name, vim_getwinvar)
# from powerline.theme import requires_segment_info, requires_filesystem_watcher
# from powerline.lib import add_divider_highlight_group
# from powerline.lib.vcs import guess, tree_status
# from powerline.lib.humanize_bytes import humanize_bytes
# from powerline.lib import wraps_saveargs as wraps
# from collections import defaultdict

vim_funcs = {
    # 'fnamemodify': vim_get_func('fnamemodify'),
    # 'expand': vim_get_func('expand'),
    # 'bufnr': vim_get_func('bufnr', rettype=int),
    # 'line2byte': vim_get_func('line2byte', rettype=int),
    'virtcol': vim_get_func('virtcol', rettype=int),
    'getline': vim_get_func('getline'),
}

def character_info(pl):
    line_contents = vim_funcs['getline']('.')
    cursor_column = int(vim_funcs['virtcol']('.'))

    if line_contents and cursor_column <= len(line_contents):
        character = line_contents.decode('utf-8')[cursor_column - 1]
        codepoint = ord(character)

        if codepoint <= 255:
            highlight_group = "current_character"
        else:
            highlight_group = "current_character_utf"

        contents = str(codepoint)

        return [
            {
                "contents": contents,
                "highlight_group": highlight_group
            }
        ]
    else:
        return None
