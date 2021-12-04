#!/bin/sh
cd $(dirname $0)
curl -L https://mau.dev/mautrix/imessage/-/jobs/artifacts/master/download?job=build+ios+armv7 -o mautrix-imessage-ios-armv7.zip
rm -f mautrix-imessage libolm.3.dylib example-config.yaml
unzip mautrix-imessage-ios-armv7.zip
rm -f mautrix-imessage-ios-armv7.zip
mv mautrix-imessage-ios-armv7/* .
rmdir mautrix-imessage-ios-armv7
