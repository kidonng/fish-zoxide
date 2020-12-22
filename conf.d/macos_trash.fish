test -z "$list_trash" && set -U list_trash ls -A

function _macos_trash_uninstall --on-event macos_trash_uninstall
    set -e list_trash
end
