::AddPropFloat <- function(entity, property, value)
{
    SetPropFloat(entity, property, GetPropFloat(entity, property) + value)
}

::AddPropInt <- function(entity, property, value)
{
    SetPropInt(entity, property, GetPropInt(entity, property) + value)
}