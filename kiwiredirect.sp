#include <sourcemod>
#include <sdktools>

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
    char arg1[265], arg2[32], arg3[32];
 
    /* Get the first argument */
    GetCmdArg(1, arg1, sizeof(arg1));
    GetCmdArg(2, arg2, sizeof(arg2));
    GetCmdArg(3, arg3, sizeof(arg3));
 
    /* If there are 2 or more arguments, and the second argument fetch 
     * is successful, convert it to an integer.
     */
    if (args < 2)
    {
        ReplyToCommand(client, "[SM] Usage: sm_redirect <#userid|name> <ip> <port>");
        return Plugin_Handled;
    }
 

    char target_name[MAX_TARGET_LENGTH];
    int target_list[MAXPLAYERS], target_count;
    bool tn_is_ml;
 
    if ((target_count = ProcessTargetString(
            arg1,
            client,
            target_list,
            MAXPLAYERS,
            COMMAND_FILTER_NO_BOTS, /* Ignore bots (this isn't needed, im just giving a placeholder value.) */
            target_name,
            sizeof(target_name),
            tn_is_ml)) <= 0)
    {
        /* This function replies to the admin with a failure message */
        ReplyToTargetError(client, target_count);
        return Plugin_Handled;
    }
 
    for (int i = 0; i < target_count; i++)
    {
        ClientCommand(target_list[i],"redirect %s:%s",arg2,arg3);
        LogAction(client, target_list[i], "\"%L\" sent \"%L\" to ip: %s", client, target_list[i], arg2);
    }
 
    if (tn_is_ml)
    {
        ShowActivity2(client, "[SM] ", "Redirected %s!", target_name);
    }
    else
    {
        ShowActivity2(client, "[SM] ", "Redirected %s!", target_name);
    }
 
    return Plugin_Handled;
}

public Action Command_Restart(int client, int args)
{
    ServerCommand("mp_restartgame 1");
    ServerCommand("sm_hsay Map Reset!");
   return Plugin_Handled;
}