#!/bin/sh

#  nibbuild.sh
#  brooklyn
#
#  Created by EthanRDoesMC on 1/1/21.
#  
cd ./Resources
find . -name "*.xib" -type f | awk '{sub(/.xib/,"");print}' | xargs -I % ibtool --compile %.nib %.xib

