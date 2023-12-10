
enum TF_CLASS_NUM
{
    UNKNOWN,
    SCOUT,
    SOLDIER,
    PYRO,
    DEMOMAN,
    HEAVY,
    ENGINEER,
    MEDIC,
    SNIPER,
    SPY
}

class TFClassUtil
{
    CacheNames =
    [
        "scout",
        "soldier",
        "pyro",
        "demo",
        "heavy",
        "engineer",
        "medic",
        "sniper",
        "spy"
    ];

    ProperNames =
    [
        "Scout",
        "Soldier",
        "Pyro",
        "Demoman",
        "Heavy",
        "Engineer",
        "Medic",
        "Sniper",
        "Spy"
    ];

    function GetCacheString(tfclass_id)
    {
        switch(tfclass_id)
        {
            case TF_CLASS_SCOUT: return CacheNames[0];
            case TF_CLASS_SNIPER: return CacheNames[7];
            case TF_CLASS_SOLDIER: return CacheNames[1];
            case TF_CLASS_DEMOMAN: return CacheNames[3];
            case TF_CLASS_MEDIC: return CacheNames[6];
            case TF_CLASS_HEAVY: return CacheNames[4];
            case TF_CLASS_PYRO: return CacheNames[2];
            case TF_CLASS_SPY: return CacheNames[8];
            case TF_CLASS_ENGINEER: return CacheNames[5];
            default: return null;
        }
    }

    function GetProperName(tfclass_id)
    {
        switch(tfclass_id)
        {
            case TF_CLASS_SCOUT: return ProperNames[0];
            case TF_CLASS_SNIPER: return ProperNames[7];
            case TF_CLASS_SOLDIER: return ProperNames[1];
            case TF_CLASS_DEMOMAN: return ProperNames[3];
            case TF_CLASS_MEDIC: return ProperNames[6];
            case TF_CLASS_HEAVY: return ProperNames[4];
            case TF_CLASS_PYRO: return ProperNames[2];
            case TF_CLASS_SPY: return ProperNames[8];
            case TF_CLASS_ENGINEER: return ProperNames[5];
            default: return null;
        }
    }

    function NumToID(class_num)
    {
        switch(class_num)
        {
            case TF_CLASS_NUM.UNKNOWN: return TF_CLASS_UNDEFINED;
            case TF_CLASS_NUM.SCOUT: return TF_CLASS_SCOUT;
            case TF_CLASS_NUM.SOLDIER: return TF_CLASS_SOLDIER;
            case TF_CLASS_NUM.PYRO: return TF_CLASS_PYRO;
            case TF_CLASS_NUM.DEMOMAN: return TF_CLASS_DEMOMAN;
            case TF_CLASS_NUM.HEAVY: return TF_CLASS_HEAVY;
            case TF_CLASS_NUM.ENGINEER: return TF_CLASS_ENGINEER;
            case TF_CLASS_NUM.MEDIC: return TF_CLASS_MEDIC;
            case TF_CLASS_NUM.SNIPER: return TF_CLASS_SNIPER;
            case TF_CLASS_NUM.SPY: return TF_CLASS_SPY;
            default: return null;
        }
    }

    function IDToNum(tfclass_id)
    {
        switch(class_num)
        {
            case TF_CLASS_UNDEFINED: return TF_CLASS_NUM.UNKNOWN;
            case TF_CLASS_SCOUT: return TF_CLASS_NUM.SCOUT;
            case TF_CLASS_SOLDIER: return TF_CLASS_NUM.SOLDIER;
            case TF_CLASS_PYRO: return TF_CLASS_NUM.PYRO;
            case TF_CLASS_DEMOMAN: return TF_CLASS_NUM.DEMOMAN;
            case TF_CLASS_HEAVY: return TF_CLASS_NUM.HEAVY;
            case TF_CLASS_ENGINEER: return TF_CLASS_NUM.ENGINEER;
            case TF_CLASS_MEDIC: return TF_CLASS_NUM.MEDIC;
            case TF_CLASS_SNIPER: return TF_CLASS_NUM.SNIPER;
            case TF_CLASS_SPY: return TF_CLASS_NUM.SPY;
            default: return null;
        }
    }
}
::TFClassUtil <- TFClassUtil();