#include <windows.h>
#include "bson.h"
#include <mex.h>

extern int sock_init();

BOOL APIENTRY DllMain(HMODULE hModule,
                      DWORD  ul_reason_for_call,
                      LPVOID lpReserved)
{
    sock_init();
    bson_printf = mexPrintf;
    bson_errprintf = mexPrintf;
    set_bson_err_handler(mexErrMsgTxt);
    return TRUE;
}

