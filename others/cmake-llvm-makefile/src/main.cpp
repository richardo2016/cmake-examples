#ifdef _WIN32
#ifndef FIB_WIN_WINAPI_H_
#define FIB_WIN_WINAPI_H_

#include <windows.h>
#endif
#endif

#include <stdio.h>

int main(int argc, char *argv[])
{
    #ifdef _WIN32
    printf("Hello WIN32!");
    #else
    printf("Hello UNIX!");
    #endif
    
    #if __cplusplus==201402L
    printf("C++14");
    #elif __cplusplus==201103L
    printf("C++11");
    #else
    printf("C++");
    #endif

    return 0;
}