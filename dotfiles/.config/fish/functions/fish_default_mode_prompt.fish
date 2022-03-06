function fish_default_mode_prompt --description 'Display the default mode for the prompt'
    # Do nothing if not in vi mode
    if test "$fish_key_bindings" = "fish_vi_key_bindings"
        or test "$fish_key_bindings" = "fish_hybrid_key_bindings"
        set_color green
        echo ''
        set_color normal
    end
end
