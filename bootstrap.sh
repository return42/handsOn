#! /usr/bin/env bash
# ----------------------------------------------------------------------------
# bootstrap *this* repository from an url
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# setup
# ----------------------------------------------------------------------------

appl="handsOn"
download_url="https://github.com/return42/${appl}/raw/master/bootstrap.sh"
git_clone_url="https://github.com/return42/${appl}.git"
BASE_PACKAGES="git"
INSTALL_CMD="sudo ./scripts/ubuntu_install_pkgs.sh base"

# ----------------------------------------------------------------------------
main(){
# ----------------------------------------------------------------------------

    case $1 in
	usage)
	    usage
	    ;;
	*)
	    bootstrap
	    ;;
    esac
}

# ----------------------------------------------------------------------------
usage() {
# ----------------------------------------------------------------------------

    cat <<EOF
usage:
    cd /folder/where/to/place/repository/clone/in
    wget --no-check -O /tmp/bs.sh "$download_url" ; bash /tmp/bs.sh
EOF
}

# ----------------------------------------------------------------------------
bootstrap() {
# ----------------------------------------------------------------------------

    rstHeading "Bootstraping $appl" part

    rstHeading "Install bootstrap requirements" chapter
    rstPkgList ${BASE_PACKAGES}
    waitKEY
    sudo apt-get install -y ${BASE_PACKAGES}

    rstHeading "cloning $appl --> $PWD/$appl" chapter
    waitKEY
    if [[ ! -z ${SUDO_USER} ]]; then
        sudo -u ${SUDO_USER} git clone "$git_clone_url" "$PWD/$appl"
    else
        git clone "$git_clone_url" "$PWD/$appl"
    fi

    rstHeading "installing $appl" chapter
    waitKEY
    cd "$PWD/$appl"
    $INSTALL_CMD
}

# ----------------------------------------------------------------------------
err_msg() {
# ----------------------------------------------------------------------------
    printf "ERROR: $*\n" >&2
}

# ----------------------------------------------------------------------------
rstHeading() {
# ----------------------------------------------------------------------------

    # usage:rstHeading <header-text> [part|chapter|section]

    case ${2-chapter} in
        part)     printf "\n${1//?/=}\n$1\n${1//?/=}\n";;
        chapter)  printf "\n${1}\n${1//?/=}\n";;
        section)  printf "\n${1}\n${1//?/-}\n";;
        *)
	    err_msg "invalid argument '${2}' in line $(caller)"
	    return 42
            ;;
    esac
}

# ----------------------------------------------------------------------------
rstBlock() {
# ----------------------------------------------------------------------------

    echo -en "\n$*\n" | fmt
}

# ----------------------------------------------------------------------------
rstPkgList() {
# ----------------------------------------------------------------------------

    echo -en "\npackage::\n\n  $*\n" | fmt
}

# ----------------------------------------------------------------------------
cleanStdIn() {
# ----------------------------------------------------------------------------
    if [[ $(uname -s) != 'Darwin' ]]; then
        while $(read -n1 -t 0.1); do : ; done
    fi
}


# ----------------------------------------------------------------------------
waitKEY(){
# ----------------------------------------------------------------------------

    # usage: waitKEY [<timeout in sec>]

    local _t=$1
    [[ ! -z $FORCE_TIMEOUT ]] && _t=$FORCE_TIMEOUT
    [[ ! -z $_t ]] && _t="-t $_t"
    shift
    cleanStdIn
    echo
    read -n1 $_t -p "** press any [KEY] to continue **"
    printf "\n"
    cleanStdIn
}


# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
