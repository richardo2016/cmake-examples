if [ -e ./build ]; then
    echo "clean existed build assets...";
    rm -rf ./build/**/*;
fi

mkdir -p build && cd build
cmake -G "Unix Makefiles" ../
make

./winapi.exe