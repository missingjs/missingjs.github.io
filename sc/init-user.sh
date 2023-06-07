#!/bin/bash

usage()
{
    local cmd=$(basename $0)
    cat <<EOF
usage: init-user.sh -n <user-name> -u <uid> -g <gid>

EOF
    exit 1
}

while getopts ':n:u:g:' option; do
    case $option in
        n)
            user_name=$OPTARG
            ;;
        u)
            user_id=$OPTARG
            ;;
        g)
            group_id=$OPTARG
            ;;
        \?)
            usage
            ;;
    esac
done

[ -z $user_name ] && usage
[ -z $user_id ] && usage
[ -z $group_id ] && usage

set -xe

groupadd --gid $group_id $user_name

useradd --uid $user_id --gid $group_id --shell /bin/bash -m $user_name

echo "$user_name ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$user_name

chmod 0440 /etc/sudoers.d/$user_name

