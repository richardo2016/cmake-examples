#include <stdio.h>
#include <processenv.h>

static const int kMaxEnvNameLength = 128;
static const DWORD kMaxEnvValueLength = 32767;

struct EnvVariable {
  char name[kMaxEnvNameLength];
  char value[kMaxEnvValueLength];
};

int main()
{
    // const char* name;
    struct EnvVariable eKv;
    const char info_tpl[] = "env{%s} is %s\n";

    GetEnvironmentVariableA("VCToolsInstallDir", eKv.value, kMaxEnvValueLength);
    printf(info_tpl, "VCToolsInstallDir", eKv.value);

    GetEnvironmentVariableA("PATH", eKv.value, kMaxEnvValueLength);
    printf(info_tpl, "PATH", eKv.value);

    GetEnvironmentVariableA("VCInstallDir", eKv.value, kMaxEnvValueLength);
    printf(info_tpl, "VCInstallDir", eKv.value);
    return 0;
}