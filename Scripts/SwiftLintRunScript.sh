if which swiftlint > /dev/null; then
  swiftlint
else
  echo "SwiftLint not installed?"
fi

#if which /usr/local/bin/swiftlint >/dev/null; then
#  cd ..
#  /usr/local/bin/swiftlint lint --lenient
#else
#    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
#fi
