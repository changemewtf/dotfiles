# vim:ft=sh

function sgrep {
    fileno=1

    _no_svn_finder -print0 |\
    xargs -0 egrep -Il "$@" |\
    tee >(sed -e "s_\./__" > ~/.sgrep_files) |\
    while read f; do
        [[ $fileno -ne 1 ]] && echo
        echo -e "$f (\033[1;36m$fileno\033[0m):" # bold cyan
        let fileno++
        egrep --color=always -n "$@" "$f"
    done
}

function sfind {
    fileno=1
    _no_svn_finder -iname "*${@}*" -print |\
    tee >(sed -e "s_\./__" > ~/.sgrep_files) |\
    while read f; do
        echo -e "$f (\033[1;36m$fileno\033[0m)" # bold cyan
        let fileno++
    done
}

function vimsgrep {
    _no_svn_finder -print0 | xargs -0 egrep -nI "$@"
}

export -f vimsgrep

function _no_svn_finder {
    SKIP_DIRS_RAW='svn'
    SKIP_EXTS_RAW='pyc pyo so o a tgz'
    SKIP_FILES_RAW='tags'

    SKIP_DIRS=$(echo $SKIP_DIRS_RAW | sed -e 's_\(\w*\)_.*/\.\1_g' | sed -e 's_ _\\\|_g')
    SKIP_EXTS=$(echo $SKIP_EXTS_RAW | sed -e 's_\(\w*\)_.*\.\1_g' | sed -e 's_ _\\\|_g')
    SKIP_FILES="$SKIP_FILES_RAW"

    find *  \
        -regex "$SKIP_DIRS" -prune , \
        -not -regex "$SKIP_EXTS" \
        -not -regex "$SKIP_FILES" \
        -type f \
        "$@"
}

export -f _no_svn_finder

function sopen {
    if [[ -f $1 ]]; then
        vim $*
    elif [[ -f $2 ]]; then
        vim $*
    else
        num=$1
        shift
        vim $* $(sed -n ${num}p <~/.sgrep_files)
    fi
}

function _sopen {
    local curw
    COMPREPLY=()
    curw=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=($(compgen -W '$( paste -d" " -s <~/.sgrep_files)' -- $curw))
    return 0
}
complete -F _sopen sopen

# automating some common svnmerge.py stuff
function mg {
    if [[ -z $(svn propget svnmerge-integrated) ]]; then
	echo "No merge tracking in this directory; aborting."
	return 1
    fi

    which=$(svn info | grep ^URL | awk -F'/' '{ print $7 }')

    if [[ $which == "trunk" ]]; then
	source="/python-lib/branches/DB-mcantor"
    elif [[ $which == "branches" ]]; then
	source="/python-lib/trunk"
    else
	echo "Unfamiliar source $which; aborting."
	return 1
    fi

    cmd=$1
    shift

    case $cmd in

	avail)
	    run="svnmerge.py avail -S $source $@"
	;;

	sw) # switch branch/trunk
	    abort_on_outstanding_changes || return 1
	    run="svn switch $@ ${AGREPO}${source}"
	;;

	up)
	    run="svnmerge.py merge -S $source $@"
	;;

	*) # passthru
	    run="svnmerge.py $cmd $@"
	;;

    esac

    echo "$run"
    eval "$run"
}

function abort_on_outstanding_changes {
    if [[ -n $(svn stat | grep -v \?) ]]; then
	echo "Uncommitted changes; aborting."
	return 1
    fi
}

# a minimal patch queue for subversion
function q {
    PATCH_FILE_NAMES=$(find $PATCH_DIR -maxdepth 1 -type f | sed -e "s|$PATCH_DIR/||")

    if [[ -z $1 ]]; then
        echo "$PATCH_FILE_NAMES" | awk '{ print NR ". " $1 }'
        return 0
    fi

    case $1 in

        -)
            echo "$PATCH_FILE_NAMES"
        ;;

        vi|di|p|ci|r|rm|cat|sv|mg|sd|cd|pu|ep)
            PFILENAME=$(q | grep ^$2 | sed -e "s/^[0-9]*\. //")
            PFILEPATH=$PATCH_DIR/$PFILENAME
            PATCH_INDEX_RAW=$(head -n1 $PFILEPATH | grep "^Index:")

            if [[ -z $PATCH_INDEX_RAW ]]; then

                echo "$PFILENAME has no Index line."
                return 1

            fi

            # XXX might be better to make the svn diff --diff-cmd -x use --normal to solidify the "single file" restriction
            # here we would just get the real file based on the filename, not the index--simpler?
            PATCH_INDEX=${PATCH_INDEX_RAW#Index: }

            if [[ ${PATCH_INDEX:0:1} = "/" ]]; then
                REALFILEPATH=$PATCH_INDEX
            else
                REALFILEPATH=$LIB/$PATCH_INDEX
            fi

            BACKUPFILEPATH=$PATCH_BACKUP_DIR/${PFILENAME%.patch}

            if [[ -z $PFILENAME ]]; then

                echo "Invalid queue number."
                return 1

            else

                case $1 in
                    # edit patch file
                    p) vim $PFILEPATH;;
                    # edit real file
                    vi) vim $REALFILEPATH;;
                    # edit change file
                    b) vim $BACKUPFILEPATH;;
                    # pull diff hunks into real file and update patch file
                    mg)
                        vim -c "silent vert rightbelow diffpatch $PFILEPATH" -c "wincmd h" $REALFILEPATH
                        # XXX might be better to make the svn diff --diff-cmd -x use --normal to solidify the "single file" restriction
                        echo "Index: $REALFILEPATH" > $PFILEPATH
                        echo "===================================================================" >> $PFILEPATH
                        diff -u $REALFILEPATH $BACKUPFILEPATH >> $PFILEPATH
                    ;;
                    # view remaining unpulled changes
                    di) view -c "silent vert rightbelow diffpatch $PFILEPATH" -c "wincmd h" $REALFILEPATH;;
                    # mark patch as applied
                    ci)
                        REV=$(svn info $REALFILE | grep "^Last Changed Rev" | sed -e "s/^Last Changed Rev: \([0-9]*\)/\1/")
                        mv $PFILEPATH $PATCH_DIR/applied/$PFILENAME-$REV
                    ;;
                    # get real file path
                    r) echo $REALFILEPATH;;
                    # get patch file path
                    ep) echo $PFILEPATH;;
                    # archive patch
                    rm) mv $PFILEPATH $PATCH_DIR/archived/$PFILENAME-$(date +"%m-%d-%y");;
                    # archive patch with message
                    sv) mv $PFILEPATH $PATCH_DIR/archived/$PFILENAME-${3-save};;
                    # output patch
                    cat) cat $PFILEPATH;;
                    # show svn diff of real file
                    sd) svn diff $REALFILEPATH;;
                    # go to directory of real file
                    cd) cd $(dirname $REALFILEPATH);;
                    # apply all changes
                    pu)
                        patch -d $(dirname $REALFILEPATH) <$PFILEPATH
                        if [[ $? -eq 0 ]]; then
                            q ci $2
                            return 0
                        else
                            return 1
                        fi
                    ;;
                esac

            fi
        ;;


        *)
            if [[ -z $(svn stat $1) ]]; then
                echo "No changes for $1."
                return 1
            fi

            ABS_PATH=$(readlink -f $1)
            SHAVE_LIB=${ABS_PATH#$LIB/}
            REPLACE_SLASHES=${SHAVE_LIB//\//.}
            BASE_NAME=$REPLACE_SLASHES${2+-$2}

            # XXX might be better to make the svn diff --diff-cmd -x use --normal to solidify the "single file" restriction
            svn diff --diff-cmd=diff $ABS_PATH > $PATCH_DIR/$BASE_NAME.patch && \
            echo -e "$PATCH_DIR/\033[0;32m$BASE_NAME\033[0m.patch" && \
            # XXX this isn't really a "backup"--it's just a snapshot of ALL changes in the queue.  should be named better
            cp $1 $PATCH_BACKUP_DIR/$BASE_NAME && \
            echo -e "$PATCH_BACKUP_DIR/\033[0;32m$BASE_NAME\033[0m" && \
            svn revert $1
        ;;

    esac
}

