class MercenaryHUD
{
    HUDPriority = 1;
    HUDID = UniqueString();

    function AddHUD(player)
    {
        HUD.Add(player, CreateIdentifier(), CreateHUDObject());
    }

    function CreateIdentifier()
    {
        return HUDIdentifier(HUDID, HUDPriority);
    }

    function CreateHUDObject()
    {
        return HUDObject(
            [
                CreateDamageChannel()
            ]
        );
    }

    function CreateDamageChannel()
    {
        return class extends HUDChannel
        {
            function OnEnabled()
            {
                Update();
            }

            function Update()
            {
                MercenaryHUD.UpdateDamageHUD(player, params);
                Display();
            }
        }(0.498, 0.788, "236 227 203", 500, 0, 0);
    }

    function UpdateDamageHUD(player, params)
    {
        local number = floor(player in MercenaryStats.TotalDamage ? MercenaryStats.TotalDamage[player] : 0);
        params.x = number < 10 ? 0.498 : number < 100 ? 0.493 : number < 1000 ? 0.491 : 0.487;
        params.message = number.tostring();
    }
}
::MercenaryHUD <- MercenaryHUD();

::Done <- false;