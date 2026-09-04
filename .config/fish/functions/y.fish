function y --description "Open yazi and cd into the last directory"
    set -l tmp (mktemp -t yazi-cwd.XXXXXX)

    command yazi $argv --cwd-file="$tmp"

    if test -f "$tmp"
        set -l cwd (cat "$tmp")

        if test -n "$cwd"; and test "$cwd" != "$PWD"; and test -d "$cwd"
            cd "$cwd"
        end

        rm -f "$tmp"
    end
end
