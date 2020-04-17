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
    return 0;
}