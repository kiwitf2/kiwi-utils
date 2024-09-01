#include <sourcemod>

public Plugin myinfo =
{
	name = "kiwi utils",
	author = "kiwi",
	description = "w.i.p",
	version = "1.0",
	url = "http://www.sourcemod.net/"
};

public void OnPluginStart()
{
    RegAdminCmd("sm_redirect", Command_Redirect, ADMFLAG_ROOT, "Redirects a player by name.");
    RegAdminCmd("sm_resetmap", Command_Restart, ADMFLAG_KICK, "Restarts a map.");
}
 
public Action Command_Redirect(int client, int args)
{
    if (args < 2)
    {
        ReplyToCommand(client, "[SM] Usage: sm_redirect <#userid|name> <server>");
        return Plugin_Handled;
    }
 
    char name[32];
    char server[32];
    int target = -1;
    GetCmdArg(1, name, sizeof(name));
    GetCmdArg(2, server, sizeof(server));
 
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientConnected(i))
        {
            continue;
        }
 
        char other[32];
        GetClientName(i, other, sizeof(other));
 
        if (StrEqual(name, other))
        {
            target = i;
        }
    }
 
    if (target == -1)
    {
        PrintToConsole(client, "Could not find any player with the name: \"%s\"", name);
        return Plugin_Handled;
    }
 
    ClientCommand(target,"redirect %s",server);
    PrintToConsole(client, "Sent %s", name," to the server: %s", server);
   return Plugin_Handled;
}

public Action Command_Restart(int client, int args)
{
    ServerCommand("mp_restartgame 1");
    ServerCommand("sm_hsay Map Reset!");
   return Plugin_Handled;
}