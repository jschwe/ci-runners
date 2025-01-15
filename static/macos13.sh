#!/bin/sh
set -eu

# Enable SSH
systemsetup -setremotelogin on

# Enable automatic login
curl -fsSO https://ci0.servo.org/static/macos13/setAutoLogin.sh
chmod +x setAutoLogin.sh
./setAutoLogin.sh servo 'servo2024!'

# Allow servo to elevate to root without password
echo 'servo  ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/servo

# Install a LaunchAgent to run our code on boot
# <https://superuser.com/a/229792>
curl -fsSO https://ci0.servo.org/static/macos13/org.servo.ci.plist
mv -v org.servo.ci.plist /Library/LaunchAgents

# Disable the Terminal.app session restore feature to avoid sketchy “command not found” errors
# - Method based on <https://apple.stackexchange.com/a/347045>
# - Another possible method (2018) <https://superuser.com/a/1303096>
# - Another method that doesn’t seem to work (2020) <https://superuser.com/a/1610999>
# - More about the errors <https://apple.stackexchange.com/q/465930>
# - More about the feature <https://apple.stackexchange.com/q/278372>
# - Possibly related feature <https://superuser.com/q/1293690>
find /Users/servo/Library/Saved\ Application\ State/com.apple.Terminal.savedState -depth +0 -delete
chflags uchg /Users/servo/Library/Saved\ Application\ State/com.apple.Terminal.savedState

# Shut down the clean image guest
shutdown -h now
