class RoundEndHUD
{
    HUDPriority = 99;
    HUDID = UniqueString();

    round_end_hudtext = "";

    function AddHUD(player, enable = false)
    {
        HUD.Add(player, CreateIdentifier(), CreateHUDObject(), enable);
    }

    function CreateIdentifier()
    {
        return HUDIdentifier(HUDID, HUDPriority);
    }

    function CreateHUDObject()
    {
        return HUDObject(
            [
                class extends HUDChannel
                {
                    function OnEnabled()
                    {
                        params.message = RoundEndHUD.round_end_hudtext;
                        Display();
                    }

                    function Update()
                    {
                        player.AddHudHideFlags(HIDEHUD_BUILDING_STATUS);
                    }
                }(0.055, 0.220, "236 227 203")
            ]
        );
    }

    function GenerateRoundEndPanel(winner)
    {
        if(isRoundBailout)
        {
            RoundEndHUD.round_end_hudtext = "";
            return;
        }

        local text = "";

        local leaderboard = GetDamageBoardSorted();

        local merc_score = 0
        local boss_score = 0
        local ent = null
        while( ent = Entities.FindByClassname(ent, "tf_team") )
        {
            local team = GetPropInt(ent, "m_iTeamNum")
            if(team == TF_TEAM_MERC)
                merc_score = GetPropInt(ent, "m_iScore");
            if(team == TF_TEAM_BOSS)
                boss_score = GetPropInt(ent, "m_iScore");
        }

        SetPropInt(pd_logic, "m_nBlueScore", boss_score);
        SetPropInt(pd_logic, "m_nRedScore", merc_score);

        for (local i = 0; i < 5; i++)
        {
            if(i >= leaderboard.len())
            {
                text += "---\n";
                continue;
            }

            local player = leaderboard[i][0];

            text += player.NetName() + " (" + GetRoundDamage(player) + ")\n"
        }

        //todo mvp

        RoundEndHUD.round_end_hudtext = text;
    }
}
::RoundEndHUD <- RoundEndHUD();