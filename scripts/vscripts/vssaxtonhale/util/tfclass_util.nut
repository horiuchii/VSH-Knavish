class TFClassUtil
{
    names = [
        "generic",
        "scout",
        "sniper",
        "soldier",
        "demo",
        "medic",
        "heavy",
        "pyro",
        "spy",
        "engineer"
    ];

    names_proper = [
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

    function GetProperClassName(class_id)
    {
        switch(class_id)
        {
            case TF_CLASS_SCOUT: return names_proper[0];
            case TF_CLASS_SNIPER: return names_proper[7];
            case TF_CLASS_SOLDIER: return names_proper[1];
            case TF_CLASS_DEMOMAN: return names_proper[3];
            case TF_CLASS_MEDIC: return names_proper[6];
            case TF_CLASS_HEAVY: return names_proper[4];
            case TF_CLASS_PYRO: return names_proper[2];
            case TF_CLASS_SPY: return names_proper[8];
            case TF_CLASS_ENGINEER: return names_proper[5];
            default: return null;
        }
    }
}
::TFClass <- TFClassUtil();