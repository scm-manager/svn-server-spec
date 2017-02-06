#!/bin/bash
echo "run base tests"
echo "==============="
bats *.bats

echo ""

echo "run issue tests"
echo "==============="
bats issues/*.bats