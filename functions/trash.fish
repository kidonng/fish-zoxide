function trash -d "Move files to the Trash"
  test -z "$argv" && set argv -h
  argparse l/list e/empty v/verbose h/help -- $argv || return
  
  if set -q _flag_help
    echo "Usage: trash <files>  Move files to the Trash"
    echo "Options:"
    echo "       -l, --list     List files in the Trash"
    echo "       -e, --empty    Empty the Trash"
    echo "       -v, --verbose  Show trashed files/stats"
    echo "       -h, --help     Show help message"
    return
  end

  if set -q _flag_list
    set trash (_list_trash)
    echo $trash | string split " "

    if set -q _flag_verbose
      set size (command du -sh ~/.Trash | string split \t)[1]
      echo trash: (count $trash) files,$size
    end

    return
  end

  if set -q _flag_empty
    read -P "Empty the Trash? [y/N] " confirm

    if test (string lower $confirm) = y
      command osascript -e 'tell app "Finder" to empty trash'
    end

    return
  end

  set files

  for arg in $argv
    set path (realpath $arg)

    if ! builtin contains $path $files
      if test -e $path
        set -a files $path
      else
        echo trash: $arg: No such file or directory
      end
    end
  end

  if test -n "$files"
    if set -q _flag_verbose
      echo $files | string split " "
    end

    # https://apple.stackexchange.com/a/162354
    set target 'the POSIX file "'$files'"'
    command osascript -e 'tell app "Finder" to move {'(string join , $target)'} to trash' > /dev/null
  end
end
