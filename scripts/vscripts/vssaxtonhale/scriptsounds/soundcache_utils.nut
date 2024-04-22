::rawPrecacheQueue <- [];
::voiceLinePrecacheQueue <- [];

function AddRawScriptSoundToQueue(sound)
{
    rawPrecacheQueue.push(sound);
}

function AddVoiceLineScriptSoundToQueue(sound)
{
    voiceLinePrecacheQueue.push(sound);
}

function PrecacheVoiceLineSoundScripts()
{
    foreach (sound in voiceLinePrecacheQueue)
    {
        foreach (name, bossTrait in bossLibrary)
        {
            PrecacheScriptSound(name + "." + sound);
        }

        foreach (name in TFClassUtil.CacheNames)
        {
            PrecacheScriptSound(name + "." + sound);
        }
    }
}

function PrecacheRawSoundScripts()
{
    foreach (sound in rawPrecacheQueue)
    {
        PrecacheScriptSound(sound);
    }
}

function AddClassToBossVOToQueue(tfclass, soundPath)
{
    foreach (name in bossList)
    {
        AddRawScriptSoundToQueue(tfclass+"."+name+"."+soundPath);
    }
}

function AddAllClassToBossVOToQueue(soundPath)
{
    foreach (name in bossList)
    {
        for (local i = TF_CLASS_SCOUT; i <= TF_CLASS_ENGINEER; i++)
        {
            AddRawScriptSoundToQueue(TFClassUtil.GetCacheString(i)+"."+name+"."+soundPath);
        }
    }
}