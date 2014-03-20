export PATH=/usr/local/bin:$HOME/.common-public/bin:$HOME/.common-private/bin:$PATH
export EDITOR='vim'
export GEMS=/usr/local/lib/ruby/gems
export PATCH_DIR=$HOME/.patches
export PATCH_BACKUP_DIR=$HOME/.pbackup
export HISTCONTROL=ignorespace:erasedups
export SRC=$HOME/code
export STUDENTS="$HOME/src/Students"
export SFORK="$HOME/src/Students-Fork"
export TENDER="$HOME/src/Instructors"

function day_of_week_number {
    day_of_week=$(date "+%A")
    case $day_of_week in
        "Monday") num='01';;
        "Tuesday") num='02';;
        "Wednesday") num='03';;
        "Thursday") num='04';;
        "Friday") num='05';;
        *) num='00';;
    esac

    echo $num;
}

function week_of_course {
    COURSE_START_DATE="022400002014"
    COURSE_START_SECONDS=$(date -j $COURSE_START_DATE "+%s")
    TODAY_SECONDS=$(date "+%s")
    DIFF_SECONDS=$(($TODAY_SECONDS - $COURSE_START_SECONDS))
    DIFF_DAYS=$(($DIFF_SECONDS / 60 / 60 / 24))
    DAYS_PER_WEEK=7
    # use an arithmetic trick to round up when we divide to get the week count
    DIFF_DAYS_ROUNDED=$(($DIFF_DAYS + ($DAYS_PER_WEEK - 1)))
    WEEK_OF_COURSE=$(($DIFF_DAYS_ROUNDED / $DAYS_PER_WEEK))

    if [ "$WEEK_OF_COURSE" -lt "10" ]; then
        echo -n "0"
    fi

    echo $WEEK_OF_COURSE
}

export WDI_DAY=$( echo $STUDENTS/w$(week_of_course)/d$(day_of_week_number) )
export WDI_DAY_FORK=$( echo $SFORK/w$(week_of_course)/d$(day_of_week_number) )

function today {
    cd $WDI_DAY
}

function today-fork {
    cd $WDI_DAY_FORK
}

if [ `uname -s` = "Darwin" ]; then
    # for building ruby on OS X Lion; apparently it doesn't like llvm
    export CC=gcc-4.2
    export PATH=$PATH:/usr/local/sbin

    if [ -f `brew --prefix`/etc/bash_completion ]; then
        . `brew --prefix`/etc/bash_completion
    fi
fi

[[ -f ~/.local/sh/.profile ]] && . ~/.local/sh/.profile

eval "$(rbenv init -)"
