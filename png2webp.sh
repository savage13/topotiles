#!/bin/bash

for file in $(find tiles -name '*.png'); do
    echo $file
    cwebp -quiet $file -o $(echo $file | sed 's/.png$/.webp/')
done
