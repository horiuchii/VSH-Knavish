class TFClassUtil
{
    CacheNames =
    [
        "generic",
        "scout",
        "soldier",
        "pyro",
        "demoman",
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

    function GetProperClassName(tfclass_id)
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

    function GetClassCacheString(tfclass_id)
    {
        switch(tfclass_id)
        {
            case TF_CLASS_SCOUT: return CacheNames[1];
            case TF_CLASS_SNIPER: return CacheNames[8];
            case TF_CLASS_SOLDIER: return CacheNames[2];
            case TF_CLASS_DEMOMAN: return CacheNames[4];
            case TF_CLASS_MEDIC: return CacheNames[7];
            case TF_CLASS_HEAVY: return CacheNames[5];
            case TF_CLASS_PYRO: return CacheNames[3];
            case TF_CLASS_SPY: return CacheNames[9];
            case TF_CLASS_ENGINEER: return CacheNames[6];
            default: return CacheNames[0];
        }
    }
}
::TFClassUtil <- TFClassUtil();