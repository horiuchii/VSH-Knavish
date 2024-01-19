#pragma semicolon 1
#pragma newdecls required

#include <sdktools>

public Plugin myinfo =
{
    name = "VScript Communicator",
    author = "Bradsparky",
    description = "Through the firing of events, allows for communication between vscript and sourcemod",
    version = "1.0",
};

#define EVENT_PROXY "tf_map_time_remaining"
#define MAX_FUNC_NAME_LENGTH 128

StringMap hFunctionCache;
StringMap hEventKeys;
StringMap hEventRefKeyValues;

enum
{
    EventScript_Bool,
    EventScript_Int,
    EventScript_Float,
    EventScript_String,
}

enum
{
	VScript_SentByValue,
	VScript_SentByRef,
	SM_SentByValue,
	SM_SentByRef,
    SM_ReceivedByRef,
}

enum struct FunctionWrapper
{
    Function func;
}

methodmap EventScript < Event
{
    public EventScript()
    {
        return view_as<EventScript>(true);
    }

    public void SetScriptBool(const char[] key, bool val)
    {
        hEventKeys.SetValue(key, EventScript_Bool);
        this.SetBool(key, val);
    }

    public void SetScriptInt(const char[] key, int val)
    {
        hEventKeys.SetValue(key, EventScript_Int);
        this.SetInt(key, val);
    }

    public void SetScriptFloat(const char[] key, float val)
    {
        hEventKeys.SetValue(key, EventScript_Float);
        this.SetFloat(key, val);
    }

    public void SetScriptString(const char[] key, char[] val)
    {
        hEventKeys.SetValue(key, EventScript_String);
        this.SetString(key, val);
    }
}

#include "../vsh_comms.sp"

public void OnPluginStart()
{
    AddNormalSoundHook(HookSound);
    RegConsoleCmd("send", SendEvent);
    ServerCommand("script_execute sm_comms.nut");
    HookEvent(EVENT_PROXY, EventReceiver_Pre, EventHookMode_Pre);
    HookEvent(EVENT_PROXY, EventReceiver_Post, EventHookMode_Post);

    hFunctionCache = new StringMap();
    hEventKeys = new StringMap();
    hEventRefKeyValues = new StringMap();
}

#include <profiler>
Action SendEvent(int client, int args)
{
    EventScript event = CreateVScriptGameEvent("SendMercVOToSM", SM_SentByRef);
    event.SetScriptBool("playsnd", true);
    event.Fire();

    bool play;
    hEventRefKeyValues.GetValue("playsnd", play);

    return Plugin_Handled;
}

EventScript CreateVScriptGameEvent(char[] szFunctionName, int protocol)
{
    hEventKeys.Clear();
    hEventRefKeyValues.Clear();
    EventScript event = view_as<EventScript>(CreateEvent(EVENT_PROXY));
    event.SetScriptString("func", szFunctionName);
    event.SetScriptInt("protocol", protocol);
    return event;
}

void EventReceiver_Pre(Event event, const char[] name, bool dontBroadcast)
{
    switch(event.GetInt("protocol"))
    {
        case VScript_SentByRef:
        {
            EventReceivedHandler(event);
        }
        default: {}
    }
}

void EventReceiver_Post(Event event, const char[] name, bool dontBroadcast)
{
    switch(event.GetInt("protocol"))
    {
        case VScript_SentByValue:
        {
            EventReceivedHandler(event);
        }
        case SM_ReceivedByRef:
        {
            StringMapSnapshot hSnap = hEventKeys.Snapshot();

            for (int i; i < hSnap.Length; i++)
            {
                int iTag;
                char szKey[256];
                hSnap.GetKey(i, szKey, sizeof(szKey));
                hEventKeys.GetValue(szKey, iTag);

                switch (iTag)
                {
                    case EventScript_Bool: hEventRefKeyValues.SetValue(szKey, event.GetBool(szKey));
                    case EventScript_Int: hEventRefKeyValues.SetValue(szKey, event.GetInt(szKey));
                    case EventScript_Float: hEventRefKeyValues.SetValue(szKey, event.GetFloat(szKey));
                    case EventScript_String:
                    {
                        char szValue[256];
                        event.GetString(szKey, szValue, sizeof(szValue));
                        hEventRefKeyValues.SetString(szKey, szValue);
                    }
                }
            }

            delete hSnap;
        }
        default: {}
    }
}

void EventReceivedHandler(Event event)
{
    char szFuncName[MAX_FUNC_NAME_LENGTH];
    event.GetString("func", szFuncName, sizeof(szFuncName));

    FunctionWrapper wrapper;
    if (!hFunctionCache.ContainsKey(szFuncName))
    {
        wrapper.func = GetFunctionByName(INVALID_HANDLE, szFuncName);
        if (wrapper.func == INVALID_FUNCTION)
        {
            return;
        }

        hFunctionCache.SetArray(szFuncName, wrapper, sizeof(wrapper));
    }
    else
    {
        hFunctionCache.GetArray(szFuncName, wrapper, sizeof(wrapper));
    }

    Call_StartFunction(INVALID_HANDLE, wrapper.func);
    Call_PushCell(event);
    Call_Finish();
}

public void TestFunc(Event event)
{
    event.SetString("test", "Passed");
}
