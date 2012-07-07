#!/bin/bash

# much easier than i thought, brew kind'a supports it ok


pushd `brew --cache`
for app in `brew search`
do
    brew fetch ${app}
done
popd
