#!/bin/bash

echo "🔨 د پښتو کیبورډ جوړول..."

# د پروژې فولډر ته تګ
cd ~/pashto-desktop-build

# که src نشته، جوړه یې کړه
if [ ! -d "src" ]; then
    mkdir -p src
fi

# د فایلونو کاپي کول
echo "📁 د فایلونو چمتو کول..."
cp src/main.js src/ 2>/dev/null || echo "⚠️ main.js په src کې واچوئ"
cp src/index.html src/ 2>/dev/null || echo "⚠️ index.html په src کې واچوئ"

# package.json جوړول
cat <<EOF > package.json
{
  "name": "pashto-keyboard",
  "version": "1.0.0",
  "description": "True Offline Portable Pashto Keyboard",
  "main": "src/main.js",
  "scripts": {
    "start": "electron .",
    "dist": "electron-builder"
  },
  "devDependencies": {
    "electron": "^30.0.0",
    "electron-builder": "^24.13.3"
  },
  "build": {
    "appId": "com.pashto.offlinekeyboard",
    "productName": "PashtoKeyboard",
    "linux": {
      "target": ["AppImage"],
      "category": "Utility"
    }
  }
}
EOF

# پخواني فایلونه پاکول
echo "🧹 پخواني فایلونه پاکیږي..."
rm -rf dist/ node_modules/ package-lock.json

# نصبول
echo "📦 انسټالیشن..."
npm install

# جوړول
echo "🏗️ اپلیکیشن جوړیږي..."
npm run dist

if [ $? -eq 0 ]; then
    echo "✅ بریالي جوړونه! اپلیکیشن چلیږي..."
    # پخوانۍ پروسه وژل
    pkill -f PashtoKeyboard 2>/dev/null
    pkill -f pashto-keyboard 2>/dev/null
    # نوی اپلیکیشن چلول
    sleep 1
    ./dist/linux-unpacked/pashto-keyboard --no-sandbox &
else
    echo "❌ جوړونه ناکامه شوه! خطا وګورئ."
    exit 1
fi