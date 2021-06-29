#!/bin/bash
# Reset in case getopts has been used previously in the shell.
OPTIND=1

version=0

function show_help {
  echo "usage:"
  echo "-a 'application certificate identifier for code signing'"
  echo "-p 'package certificate identifer for installers"
  echo "-e /path/to/entitlements.plist"
  echo "-b 'com.bundle.identifier.'"
  echo "-f /path/to/executable/to/be/packaged"
  echo "-i /installation/path"
  echo "-u 'username@host.com'"
  echo "-w '@keychain:App_specific_password'"
}

function show_certs {
  echo "Missing one or more cetification identities!"
  echo "choose one of these application certs for code signing"
  echo "and one of these installer certs for packaging installers"
  echo ""
  security find-identity -p basic -v
}


function sign {
  codesign --deep --force --options=runtime --entitlements $entitlements --sign $code_sign_cert --timestamp $exe_path
}


function build {
  tmp_path="/tmp/$(basename $exe_path)"
  base=$(basename $exe_path)
  tmp_path=$(mktemp -d -t $base)
  echo "temp path: $tmp_path"

  ditto $exe_path $tmp_path/$install_path/
  productbuild --identifier "$bundle_id.pkg" --sign $package_sign_cert --timestamp --root $tmp_path / ./"$(basename $exe_path).pkg"
  echo "cleaning temp path"
#  rm -rf $tmp_path
}

function notarize {
  xcrun altool --notarize-app --primary-bundle-id $bundle_id --username=$username --password $password --file $(basename $exe_path).pkg
}


function staple {
  xcrun staple stapler $(basename $exe_path).pkg
}

function check_status {
  xcrun altool --notarization-history 0 -u $username -p $password
  echo "run the command below to check the recent notarization status"
  echo "xcrun altool --notarization-history 0 -u $username -p $password"
  echo "."
  echo "after successful notarization run:"
  echo "xcrun stapler staple $(basename $exe_path).pkg"

}

req_count=0
req_num=7

help=false

while getopts "ha:p:e:b:f:i:u:w:" opt; do
  case "$opt" in
  h)
    show_help
    exit 0
    ;;
  a) code_sign_cert=$OPTARG
    ;;
  p) package_sign_cert=$OPTARG
    ;;
  e) entitlements=$OPTARG
    ;;
  b) bundle_id=$OPTARG
    ;;
  f) exe_path=$OPTARG
    ;;
  i) install_path=$OPTARG
    ;;
  u) username=$OPTARG
    ;;
  w) password=$OPTARG
    ;;
  esac
done

[ "${1:-}" = "--" ] && shift

if [[ -z $code_sign_cert  ]] || [[ -z $package_sign_cert ]]; then
  show_certs
  help=true
fi

if [[ -z $entitlements ]]; then
  echo "missing /path/to/entitlements.plist"
  help=true
fi

if [[ -z $bundle_id ]]; then
  echo "missing bundle id: com.foo.bar"
  help=true
fi

if [[ -z $exe_path ]]; then
  echo "missing /path/to/executable"
  help=true
fi

if [[ -z $install_path ]]; then
  echo "missing install location -- this is typically '/Applications/'"
  help=true
fi

if [[ -z $username ]]; then
  echo "missing developer username"
  help=true
fi

if [[ -z $password ]]; then
  echo "missing app-specific password -- this should be stored in your keychain"
  echo "and can be accessed using '@keychain:Item-Name"
  help=true
fi

if $help; then
  show_help
  exit
fi


sign
build
notarize
check_status

#if [[ $req_count -lt req_num ]]; then
#  echo "missing options"
#  show_help
#fi
