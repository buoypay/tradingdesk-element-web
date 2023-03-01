split-bundle:
  #!/usr/bin/env bash
  set -euxo pipefail
  rm -rf ./webapp-split
  mkdir -p ./webapp-split
  cd webapp-split

  # copy in everything, maintaining the directory structure
  cp -R ../webapp ./elementassets
  cp -R ../webapp ./elementbundle
  cp -R ../webapp ./elementvendor
  cp -R ../webapp ./elementmain 

  # now strip out stuff for each dir - we do this to keep a consistent dir
  # structure and make rewriting the urls easier
  find ./elementassets -mindepth 1 ! -regex '^./elementassets/fonts\(/.*\)?*' -delete
  find ./elementbundle -mindepth 1 ! -regex '^./elementbundle/bundles\(/.*\)?*' -delete
  find ./elementvendor -mindepth 1 ! -regex '^./elementvendor/bundles\(/.*\)?*' -delete
  find ./elementvendor/bundles/* -mindepth 1 -maxdepth 1 -type f -not -name "vendor*" -delete
  rm -rf ./elementbundle/bundles/*/vendor*
  rm -rf ./elementmain/bundles
  rm -rf ./elementmain/fonts

  # we can probably saftely remove KaTeX and Twemoji
  # TODO: make these external links
  # rm -rf ./elementassets/fonts/Twemoji* ./elementassets/fonts/KaTeX*

  # # keep only english languages
  mv ./elementmain/i18n ./elementmain/i18n_tmp
  mkdir -p ./elementmain/i18n
  mv ./elementmain/i18n_tmp/en* ./elementmain/i18n/
  mv ./elementmain/i18n_tmp/lang* ./elementmain/i18n/
  rm -rd ./elementmain/i18n_tmp

serve-split-bundle:
  #!/usr/bin/env bash
  set -euxo pipefail
  cd webapp-split
  python3 -m http.server 9000


server-orig-bundle:
  cd webapp; python3 -m http.server 9000

rewrite-routes:
  ./scripts/rewrite_bundle_paths.js
