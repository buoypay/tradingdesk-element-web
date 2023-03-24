export VERSION := "1.11.27-gtxn"

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
  # keep vendor* and init.js in elementvendor to optimize bundle sizes
  find ./elementvendor/bundles/* -mindepth 1 -maxdepth 1 -type f | sort | grep -v -E "(\/vendor*)|(\/init)" | xargs rm -rf
  rm -rf ./elementbundle/bundles/*/vendor*
  rm -rf ./elementbundle/bundles/*/init.js
  rm -rf ./elementmain/bundles
  rm -rf ./elementmain/fonts

  # for some reason we can't rewrite the imports for compatibility-view.css easily
  # copy into elementmain for now
  # create the file structure again
  find ./elementbundle -mindepth 1 -type d | awk '{sub(/elementbundle/, "elementmain")} {print $1}' | xargs mkdir -p
  cp ./elementbundle/bundles/*/compat*css ./elementmain/bundles/*/

  # we can probably saftely remove KaTeX and Twemoji
  rm -rf ./elementassets/fonts/Twemoji* ./elementassets/fonts/KaTeX*
  
  # keep only english languages
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


serve-orig-bundle:
  cd webapp; python3 -m http.server 9000

rewrite-routes:
  ./scripts/rewrite_bundle_paths.js


docker-prepare:
  # copy in js-sdk and react-sdk to this context
  rm -rf ./tmp
  mkdir -p tmp
  cp -R ../tradingdesk-matrix-js-sdk ./tmp/js-sdk 
  cp -R ../tradingdesk-matrix-react-sdk ./tmp/react-sdk
  rm -rf ./tmp/js-sdk/node_modules
  rm -rf ./tmp/react-sdk/node_modules

docker-build:
  docker build . --platform linux/amd64 -t element-web:local \
    --build-arg USE_CUSTOM_SDKS=true
  rm -rf ./tmp

docker-publish:
  @echo "Tagging local with version: ${VERSION}"
  docker tag element-web:local europe-west3-docker.pkg.dev/buoy-money/gtxn-docker-repo/element-web:v${VERSION}
  docker push europe-west3-docker.pkg.dev/buoy-money/gtxn-docker-repo/element-web:v${VERSION}
