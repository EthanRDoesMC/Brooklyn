#!/bin/sh
cd $(dirname $0)
curl -L https://mau.dev/mautrix/imessage/-/jobs/artifacts/master/download?job=build%20armv7 -o mautrix-imessage-armv7.zip
rm -f mautrix-imessage libolm.3.dylib example-config.yaml
unzip mautrix-imessage-armv7.zip
rm -f mautrix-imessage-armv7.zip
