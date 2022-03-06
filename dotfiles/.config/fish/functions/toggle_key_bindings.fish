function toggle_key_bindings
    if test $fish_key_bindings = "fish_default_key_bindings"
        fish_vi_key_bindings
        set -g pure_reverse_prompt_symbol_in_vimode false
    else
        fish_default_key_bindings
        set -g pure_reverse_prompt_symbol_in_vimode true
    end
end
