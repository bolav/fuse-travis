#!/bin/sh

# http://stackoverflow.com/questions/27671854/travis-ci-fails-to-build-with-a-code-signing-error

KEY_CHAIN=ios-build.keychain
security create-keychain -p travis $KEY_CHAIN
# Make the keychain the default so identities are found
security default-keychain -s $KEY_CHAIN
# Unlock the keychain
security unlock-keychain -p travis $KEY_CHAIN
# Set keychain locking timeout to 3600 seconds
security set-keychain-settings -t 3600 -u $KEY_CHAIN

# Add certificates to keychain and allow codesign to access them
security import ./.travis/certs/dist.cer -k $KEY_CHAIN -T /usr/bin/codesign
security import ./.travis/certs/dev.cer -k $KEY_CHAIN -T /usr/bin/codesign

security import ./.travis/certs/dist.p12 -k $KEY_CHAIN -P DISTRIBUTION_KEY_PASSWORD  -T /usr/bin/codesign
security import ./.travis/certs/dev.p12 -k $KEY_CHAIN -P DEVELOPMENT_KEY_PASSWORD  -T /usr/bin/codesign

echo "list keychains: "
security list-keychains
echo " ****** "

echo "find indentities keychains: "
security find-identity -p codesigning  ~/Library/Keychains/ios-build.keychain
echo " ****** "

# Put the provisioning profile in place
mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp "./.travis/profiles/iOSTeam_Provisioning_Profile_.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
cp "./.travis/profiles/DISTRIBUTION_PROFILE_NAME.mobileprovision" ~/Library/MobileDevice/Provisioning\ Profiles/
