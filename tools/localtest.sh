#!/usr/bin/env bash
DEST=_site
QUITE='false'
KILL='false'
BASEURL="$DEST$(grep '^baseurl:' _config.yml | sed "s/.*: *//;s/['\"]//g;s/#.*//")"
URL_IGNORE=cdn.jsdelivr.net

print_usage() {
  cat << "EOF"
    Utilizzo
       bash ./tools/localtest.sh [flags]

    Flags
        -h  Stampa questo help
        -q  Non verbose proof run
        -k  Killa eventuali processi Jekyll in serve
EOF
}


while getopts 'qkh' flag; do
  case "${flag}" in
    q) QUITE='true' ;;
    k) KILL='true' ;;
    h) print_usage
       exit 1 ;;
    *) print_usage
       exit 1 ;;
  esac
done


if [ "$KILL" = "true" ]; then
  ps aux | grep "jekyll" | awk '{print $2}' | xargs kill -9 > /dev/null 2>&1
fi

if [ "$QUITE" = "false" ]; then

  PROOF_ERROR='Ykes! HTML Proof found something bad...'

  bundle exec jekyll b -d $BASEURL

  bundle exec htmlproofer "$DEST" \
  --disable-external \
  --check-html \
  --empty_alt_ignore \
  --allow_hash_href \
  --url_ignore $URL_IGNORE
else

  PROOF_ERROR="Ykes! HTML Proof found something bad... Run without -q flag to see what's wrong..."

  bundle exec jekyll b -q -d $BASEURL

  bundle exec htmlproofer "$DEST" \
  --disable-external \
  --check-html \
  --empty_alt_ignore \
  --allow_hash_href \
  --url_ignore $URL_IGNORE \
  --log-level :error \
  > /dev/null 2>&1
fi


EXITCODE=$?
test $EXITCODE -eq 0 && echo "HTML Proof OK!" || echo $PROOF_ERROR;
exit $EXITCODE