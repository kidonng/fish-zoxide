function trash -d "Move files to the Trash"
    test -z "$argv" && set argv --help
    argparse l/list e/empty v/verbose h/help -- $argv || return

    if set -q _flag_list
        _trash_list $_flag_verbose
        return
    else if set -q _flag_empty
        _trash_empty
        return
    else if set -q _flag_help
        _trash_help
        return
    end

    set paths

    for arg in $argv
        set path (builtin realpath -s $arg)

        if builtin contains $path $paths
            continue
        end

        if test -e $path || test -L $path
            set -a paths $path
        else
            echo trash: $arg does not exist
            set error
        end
    end

    if test -n "$paths"
        if set -q _flag_verbose
            string collect $paths
        end

        # https://apple.stackexchange.com/a/162354
        set files 'POSIX file "'$paths'"'
        command osascript -e 'tell app "Finder" to move {'(string join , $files)'} to trash' >/dev/null
    end

    if set -q error
        return 1
    end
end
