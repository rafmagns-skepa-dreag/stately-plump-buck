fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/tools/bin

if status is-interactive
    set -gx EDITOR nvim
    set -gx LANG en_US.UTF-8
    set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
    set -gx MANROFFOPT -c # required to make MANPAGER work correctly
    set -gx BAT_THEME gruvbox-dark

    starship init fish | source

    abbr --add vi /usr/bin/vim
    abbr --add vim nvim
    abbr --add pcr pre-commit run
    abbr --add rga rg -A 1
    abbr --add git-clean "git fetch -p && git branch -vv | rg -v '(\*|\+)' | awk '/: gone]/{print \$1}' | xargs -r git branch -D"
    abbr --add cat bat
    abbr --add find fd
    abbr --add z zenith
    abbr --add gst git status
    abbr --add ga git add
    abbr --add gc git commit
    abbr --add gp git push
    abbr --add ls exa

    atuin init fish | source
end
