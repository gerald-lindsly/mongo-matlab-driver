#include <windows.h>

extern int sock_init();

BOOL APIENTRY DllMain(HMODULE hModule,
                      DWORD  ul_reason_for_call,
                      LPVOID lpReserved)
{
    sock_init();
    return TRUE;
}

