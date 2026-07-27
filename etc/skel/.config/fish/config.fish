# Commands to run in interactive sessions can go here
if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship
    function starship_transient_prompt_func
        starship module character
    end
    if test "$TERM" != "linux"
        starship init fish | source
        enable_transience
    end

    # Aliases
    alias clear "printf '\\033[2J\\033[3J\\033[1;1H'"
    alias celar "printf '\\033[2J\\033[3J\\033[1;1H'"
    alias claer "printf '\\033[2J\\033[3J\\033[1;1H'"
    alias pamcan pacman
    if test "$TERM" != "linux"
        alias ls 'eza --icons'
    end
    if test "$TERM" = "xterm-kitty"
        alias ssh 'kitten ssh'
    end
end
