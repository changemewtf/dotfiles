#!/usr/bin/env bash

# one-liner:
#( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done; )

aa_256 ()
{
    ( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;
    for i in {0..256};
    do
        o=00$i;
        echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;
    done )
}

aa_256
