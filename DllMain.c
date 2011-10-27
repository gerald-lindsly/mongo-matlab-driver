#ifdef _WIN32
#include <windows.h>
#endif

#include "bson.h"
#include <mex.h>

extern int sock_init();


int main(void)
{
    sock_init();
    bson_printf = mexPrintf;
    bson_errprintf = mexPrintf;
    set_bson_err_handler(mexErrMsgTxt);
    return 0;
}

#ifdef _WIN32
BOOL APIENTRY DllMain(HMODULE hModule,
                      DWORD  ul_reason_for_call,
                      LPVOID lpReserved)
{
    main();
    return TRUE;
}
#endif

