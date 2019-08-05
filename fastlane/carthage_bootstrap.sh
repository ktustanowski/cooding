#!/bin/bash

carthage bootstrap --platform iOS
cd Core
carthage bootstrap --platform iOS
cd ..
