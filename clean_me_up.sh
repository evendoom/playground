#!/bin/bash

find /workspace/playground/ads/volume_3/detox_test/ -type f -print0 | \
perl -n0e '$new = $_; if($new =~ s/[a-zA-Z0-9]/_/g) {
  print("Renaming $_ to $new\n"); rename($_, $new);
}'