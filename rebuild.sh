#!/bin/bash

echo "🔨 د پښتو کیبورډ جوړول..."

# د پروژې فولډر ته تګ
cd ~/pashto-desktop-build

# که src نشته، جوړه یې کړه
if [ ! -d "src" ]; then
    mkdir -p src
fi

# د فایلونو کاپي کول (خپل پرمختللي فایلونه دلته کاپي کړئ)
echo "📁 د فایلونو چمتو کول..."
# ډاډ ترلاسه کړئ چې ستاسو پرمختللی main.js او index.html په src کې دي
# که نه، نو له بل ځایه یې کاپي کړئ

# بشپړ package.json جوړول (د GitHub نسخه + ستاسو سکریپټ)
cat <<'EOF' > package.json
{
  "name": "pashto-keyboard",
  "version": "1.0.0",
  "description": "True Offline Portable Pashto Keyboard",
  "main": "src/main.js",
  "author": "iPashto AI <ipashto-ai@example.com>",
  "homepage": "https://github.com/spinzar/pashto-keyboard-public#readme",
  "license": "Apache-2.0",
  "scripts": {
    "start": "electron .",
    "dist": "electron-builder",
    "dist:deb": "electron-builder --linux deb",
    "dist:appimage": "electron-builder --linux AppImage"
  },
  "devDependencies": {
    "electron": "^30.0.0",
    "electron-builder": "^24.13.3"
  },
  "build": {
    "appId": "com.spinzar.pashtokeyboard",
    "productName": "PashtoKeyboard",
    "directories": {
      "buildResources": "assets"
    },
    "linux": {
      "target": ["deb", "AppImage"],
      "category": "Utility",
      "maintainer": "iPashto AI <ipashto-ai@example.com>",
      "icon": "assets/icons"
    },
    "deb": {
      "maintainer": "iPashto AI <ipashto-ai@example.com>",
      "compression": "xz"
    }
  }
}
EOF

# د assets/icons فولډر چک کول (د آیکونونو لپاره)
if [ ! -d "assets/icons" ]; then
    echo "⚠️ اخطار: د assets/icons فولډر نشته. آیکونونه به نه وي."
    mkdir -p assets/icons
fi

# پخواني فایلونه پاکول
echo "🧹 پخواني فایلونه پاکیږي..."
rm -rf dist/ node_modules/ package-lock.json

# نصبول
echo "📦 انسټالیشن..."
npm install

# دواړه پیکجونه جوړول (deb او AppImage)
echo "🏗️ اپلیکیشن جوړیږي..."
npm run dist

if [ $? -eq 0 ]; then
    echo "✅ بریالي جوړونه!"
    echo "📦 جوړ شوي فایلونه په dist/ فولډر کې دي:"
    ls -la dist/*.deb dist/*.AppImage 2>/dev/null || echo "فایلونه وموندل شول"
    
    # پخوانۍ پروسه وژل
    pkill -f PashtoKeyboard 2>/dev/null
    pkill -f pashto-keyboard 2>/dev/null
    
    # نوی اپلیکیشن چلول (که AppImage شتون ولري)
    if [ -f "dist/*.AppImage" ]; then
        echo "🚀 اپلیکیشن چلیږي..."
        sleep 1
        ./dist/*.AppImage --no-sandbox &
    fi
else
    echo "❌ جوړونه ناکامه شوه! خطا وګورئ."
    exit 1
fi