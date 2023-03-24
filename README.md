# tradingdesk-element-web

Forked from element-web. See [README_original](./README_original.md) for more information on the project.

## Developing Locally

This project depends on our forks of `matrix-react-sdk` and `matrix-js-sdk`:
- [tradingdesk-matrix-react-sdk](https://github.com/buoypay/tradingdesk-matrix-react-sdk)
- [tradingdesk-matrix-js-sdk](https://github.com/buoypay/tradingdesk-matrix-js-sdk)

Make sure these projects are checked out in the same directory as this one:

```bash
git clone git@github.com:buoypay/tradingdesk-matrix-js-sdk.git
pushd tradingdesk-matrix-js-sdk
yarn link
yarn install
popd
```

Then similarly with `matrix-react-sdk`:

```bash
git clone git@github.com:buoypay/tradingdesk-matrix-react-sdk.git
pushd tradingdesk-matrix-react-sdk
yarn link
yarn link matrix-js-sdk
yarn install
popd
```

Then, in this repository:

```bash
cd tradingdesk-element-web
yarn link matrix-js-sdk
yarn link matrix-react-sdk
yarn install
yarn start
```

## Splitting the Bundle

In order to get under the 5MB limit of Salesforce static resources, we need to strategically split the bundle up
across multiple locations. This requires a lot of hacking around, but most of the work is in theory changing
relative paths in the complied code into absolute paths with the prefixes: `$PUBLIC_PATH/elementassets`, `$PUBLIC_PATH/elementbundle`,
`$PUBLIC_PATH/elementmain`, `$PUBLIC_PATH/elementmain`.

`$PUBLIC_PATH` is by default `http://localhost:8080/`, which makes everything work nicely with a the local webpack
dev server, but when building for salesforce, set this to `http://localhost:9000/elementmain/`.

From there, you can also replace this with a brute force find-and-replace (see how we do it for deploying on Salesforce [here](https://github.com/buoypay/tradingdesk-lwc/blob/master/scripts/rewrite_bundle_paths.js))


## Build + Run Locally

```bash
# with split bundle
export SHOULD_SPLIT_BUNDLE=true
export PUBLIC_PATH=http://localhost:9000/elementmain/

yarn
yarn build

# split bundle into different paths
just split-bundle

# serve the split bundle
just serve-split-bundle

# go to http://localhost:9000/elementmain and see it working!


# without split bundle
export SHOULD_SPLIT_BUNDLE=false

yarn build
just serve-orig-bundle

```


