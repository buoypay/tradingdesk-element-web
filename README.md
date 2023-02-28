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


## Building Locally

```bash
yarn
yarn build
```


