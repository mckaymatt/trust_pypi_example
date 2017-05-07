# This script takes care of testing your crate

set -ex

main() {
    cross build --target $TARGET
    cross build --target $TARGET --release

    if [ ! -z $DISABLE_TESTS ]; then
        return
    fi

    cross test --target $TARGET
    cross test --target $TARGET --release

    cross run --target $TARGET
    cross run --target $TARGET --release
}

pymain() {
    . ~/.venv/bin/activate
    make test
    make lint

    python setup.py bdist_wheel
    ls -la dist/
}


# move into rust project subdir
pushd trust_pypi_example/rust/
# we don't run the "test phase" when doing deploys
if [ -z $TRAVIS_TAG ]; then
    main
fi

popd
pymain