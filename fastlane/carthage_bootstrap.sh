#!/bin/bash

carthage bootstrap --platform iOS --no-use-binaries
cd Core
carthage bootstrap --platform iOS --no-use-binaries
cd ..
