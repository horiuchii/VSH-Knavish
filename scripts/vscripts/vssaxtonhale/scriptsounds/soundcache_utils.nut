::genericPrecacheQueue <- [];
::voiceLinePrecacheQueue <- [];

function AddGenericScriptSoundToQueue(sound)
{
    genericPrecacheQueue.push(sound);
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

        foreach (name in TFClass.names)
        {
            PrecacheScriptSound(name + "." + sound);
        }
    }
}

function PrecacheGenericSoundScripts()
{
    foreach (sound in genericPrecacheQueue)
    {
        PrecacheScriptSound(sound);
    }
}