#!/usr/bin/env bash
# -*- coding: utf-8; mode: sh -*-
# ----------------------------------------------------------------------------
# Purpose:     install certs from a remote server
# ----------------------------------------------------------------------------

source $(dirname ${BASH_SOURCE[0]})/setup.sh

REMOTE_HOST=""
REMOTE_PORT=443

# ----------------------------------------------------------------------------
main(){
    rstHeading "SSL Zertifikate & CA's" part
# ----------------------------------------------------------------------------

    rstBlock "Anmerkungen zu SSL und Zertifikaten siehe:

  http://return42.github.io/handsOn/excursion/ssl_ca_remarks.html
"
    case $1 in

        install)
            sudoOrExit
            install_remote_cert
            ;;
        show)
            show_remote_cert
            ;;
        CA)
            sudoOrExit
            rstHeading "Vertrauenswürdige CA's"
            rstBlock "Aktivieren Sie in dem folgendem Dialog die vertrauenswürdigen CA's."
            waitKEY
            dpkg-reconfigure ca-certificates
            ;;
        *)
            echo
            echo "usage $0 [install|show]"
            echo
            echo "  show:     Anzeigen des Zertifikats eines Remote-Host."
            echo "  install:  Installieren des Zertifikats eines Remote-Host"
            echo "  CA:       Rekonfiguration der CA's."
            echo
            ;;
    esac
}

# ----------------------------------------------------------------------------
show_remote_cert(){
    rstHeading "Anzeigen eines Server Zertifikats"
# ----------------------------------------------------------------------------

    ask REMOTE_HOST "Hostname:" "${REMOTE_HOST}"
    ask REMOTE_PORT "Port:"     "${REMOTE_PORT}"

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
openssl s_client -showcerts \
    -connect ${REMOTE_HOST}:${REMOTE_PORT} </dev/null 2>/dev/null \
    | openssl x509 -text
EOF
}
# ----------------------------------------------------------------------------
install_remote_cert(){
    rstHeading "Installieren des Zertifikats eines Remote-Host"
# ----------------------------------------------------------------------------

    ask REMOTE_HOST "Hostname:" "${REMOTE_HOST}"
    ask REMOTE_PORT "Port:"     "${REMOTE_PORT}"
    ask PREFIX      "Präfix:"   "intranet"

    local folder="/usr/share/ca-certificates/${PREFIX}"
    local crt_file="$folder/host-$(echo $REMOTE_HOST | sed 's/^\.//; s/\..*$//')-$REMOTE_PORT.crt"

    rstBlock "Es wird versucht, das Zertifikat vom Server hier auf den
Client zu kopieren::"

    waitKEY
    mkdir "$folder"

    TEE_stderr <<EOF | bash 2>&1 | prefix_stdout
openssl s_client -showcerts \
    -connect ${REMOTE_HOST}:${REMOTE_PORT} </dev/null 2>/dev/null \
    | openssl x509 -outform PEM >${crt_file}
EOF
    if [[ ! -e ${crt_file} ]]; then

        echo
        err_msg "Zertifikat konnte nicht ermittelt werden!

Wenn der Server ein Zertifikat anbietet, sollte es (jetzt) manuell in den
folgenden Ordner hier auf dem LDAP-Client kopiert werden.::${Yellow}

   ${crt_file}

${Red}Erst danach kann mit der Installation fortgefahren werden.${_color_Off}
"
        waitKEY
    fi
    rstBlock "Aktivieren Sie in dem folgendem Dialog das Zertifikat:

  ${Yellow}${PREFIX}/$(basename ${crt_file})${_color_Off}
"
    waitKEY
    dpkg-reconfigure ca-certificates

}

# ----------------------------------------------------------------------------
main "$@"
# ----------------------------------------------------------------------------
