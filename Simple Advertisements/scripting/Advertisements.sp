/* [ Includes ] */
#include <sourcemod>
#include <sdktools>
#include <multicolors>

/* [ Compiler Options ] */
#pragma newdecls required
#pragma semicolon 1

/* [ Defines ] */
#define PluginTag 	"[ TAG PRZED REKLAMĄ ]"

/* [ Handles ] */
Handle g_hTimer;

/* [ KeyValues ] */
KeyValues kv;

/* [ Plugin Author and Informations ] */
public Plugin myinfo =
{
	name = "[CS:GO] Advertisements",
	author = "Yamakashi",
	description = "Plugin wyświetla reklamy na chacie.",
	version = "1.0",
	url = "https://steamcommunity.com/id/yamakashisteam"
};

/* [ Plugin Startup ] */
public void OnPluginStart()
{
	/* [ Commands ] */
	RegAdminCmd("sm_reload", ReloadAdvertisements_CMD, ADMFLAG_ROOT, "[ Reklamy ] Wywołuje reload pliku .cfg");
}

/* [ Standart Actions ] */
public void OnMapStart()
{
	Load_Advertisemensts();
	g_hTimer = CreateTimer(35.0, Print_Advertisement, _, TIMER_REPEAT);
}

public void OnMapEnd()
{
	KillTimer(g_hTimer, false);
	g_hTimer = INVALID_HANDLE;
}

/* [ Commands ] */
public Action ReloadAdvertisements_CMD(int client, int args)
{
	Load_Advertisemensts();
	return Plugin_Handled;
}

/* [ Timers ] */
public Action Print_Advertisement(Handle timer)
{
	char sAdvertisement[512];
	kv.GetString("advertisement", sAdvertisement, sizeof(sAdvertisement));
	
	CPrintToChatAll(sAdvertisement, PluginTag);
	if(!kv.GotoNextKey()) 
	{
        kv.Rewind();
        kv.GotoFirstSubKey();
    }
}

/* [ Config ] */
public void Load_Advertisemensts()
{
	delete kv;
	kv = CreateKeyValues("Advertisements");

	char sPath[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sPath, sizeof(sPath), "configs/Advertisements.cfg");

	if(!FileExists(sPath))
		SetFailState("[ X REKLAMY X ] Nie odnaleziono pliku konfiguracyjnego: %s", sPath);

	kv.ImportFromFile(sPath);
	kv.GotoFirstSubKey();
}