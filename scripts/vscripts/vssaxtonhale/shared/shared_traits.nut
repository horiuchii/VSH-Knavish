::sharedTraitLibrary <- [];

class SharedTrait extends CharacterTrait
{
    trait_team = TF_TEAM_ANY;
}
::SharedTrait <- SharedTrait;

Include("/shared/shared_traits/glow.nut");
Include("/shared/shared_traits/reset_statuses.nut");