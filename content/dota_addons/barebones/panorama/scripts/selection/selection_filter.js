// Defines scripts to set selection redirects

var DESELECT_BUILDINGS = false; // Get only the units when units&buildings are on the same list
var SELECT_ONLY_BUILDINGS = true; // Get only the buildings when units&buildings are on the same list
var DISPLAY_RANGE_PARTICLE = true; // Uses the main selected entity to update a particle showing attack range
var rangedParticle

function SelectionFilter( entityList ) {
    
    if (DESELECT_BUILDINGS) {
        if (entityList.length > 1 && IsMixedBuildingSelectionGroup(entityList) ){
            $.Schedule(1/60, DeselectBuildings) 
        }
    }

    else if (SELECT_ONLY_BUILDINGS) {
        if (entityList.length > 1 && IsMixedBuildingSelectionGroup(entityList) ){
            $.Schedule(1/60, SelectOnlyBuildings)   
        }
    }

    if (DISPLAY_RANGE_PARTICLE) {
        var mainSelected = Players.GetLocalPlayerPortraitUnit();

        // Remove old particle
        if (rangedParticle)
            Particles.DestroyParticleEffect(rangedParticle, true)

        // Create range display on the selected ranged attacker
        if (IsCustomBuilding(mainSelected) && Entities.HasAttackCapability(mainSelected))
        {
            var range = Entities.GetAttackRange(mainSelected)
            rangedParticle = Particles.CreateParticle("particles/ui_mouseactions/range_display.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, mainSelected)
            var position = Entities.GetAbsOrigin(mainSelected)
            position[2] = 380 //Offset
            Particles.SetParticleControl(rangedParticle, 0, position)
            Particles.SetParticleControl(rangedParticle, 1, [range, 0, 0])
        }
    }

    for (var i = 0; i < entityList.length; i++) {
        var overrideEntityIndex = GetSelectionOverride(entityList[i])
        if (overrideEntityIndex != -1) {
            GameUI.SelectUnit(overrideEntityIndex, false);
        }
    };
}

function DeselectBuildings() {
    var iPlayerID = Players.GetLocalPlayer();
    var selectedEntities = Players.GetSelectedEntities( iPlayerID );
    
    skip = true;
    var first = FirstNonBuildingEntityFromSelection(selectedEntities)
    GameUI.SelectUnit(first, false); // Overrides the selection group

    for (var unit of selectedEntities) {
        skip = true; // Makes it skip an update
        if (!IsCustomBuilding(unit) && unit != first){
            GameUI.SelectUnit(unit, true);
        }
    }
}

function FirstNonBuildingEntityFromSelection( entityList ){
    for (var i = 0; i < entityList.length; i++) {
        if (!IsCustomBuilding(entityList[i])){
            return entityList[i]
        }
    }
    return 0
}

function GetFirstUnitFromSelectionSkipUnit ( entityList, entIndex ) {
    for (var i = 0; i < entityList.length; i++) {
        if ((entityList[i]) != entIndex){
            return entityList[i]
        }
    }
    return 0
}

// Returns whether the selection group contains both buildings and non-building units
function IsMixedBuildingSelectionGroup ( entityList ) {
    var buildings = 0
    var nonBuildings = 0
    for (var i = 0; i < entityList.length; i++) {
        if (IsCustomBuilding(entityList[i])){
            buildings++
        }
        else {
            nonBuildings++
        }
    }
    return (buildings>0 && nonBuildings>0)
}

function SelectOnlyBuildings() {
    var iPlayerID = Players.GetLocalPlayer();
    var selectedEntities = Players.GetSelectedEntities( iPlayerID );
    
    skip = true;
    var first = FirstBuildingEntityFromSelection(selectedEntities)
    GameUI.SelectUnit(first, false); // Overrides the selection group

    for (var unit of selectedEntities) {
        skip = true; // Makes it skip an update
        if (IsCustomBuilding(unit) && unit != first){
            GameUI.SelectUnit(unit, true);
        }
    }
}

function FirstBuildingEntityFromSelection( entityList ){
    for (var i = 0; i < entityList.length; i++) {
        if (IsCustomBuilding(entityList[i])){
            return entityList[i]
        }
    }
    return 0
}

function IsCustomBuilding( entityIndex ){
    var ability_building = Entities.GetAbilityByName( entityIndex, "ability_building")
    var ability_tower = Entities.GetAbilityByName( entityIndex, "ability_tower")
    return (ability_building != -1 || ability_tower != -1)
}

function IsMechanical( entityIndex ) {
    var ability_siege = Entities.GetAbilityByName( entityIndex, "ability_siege")
    return (ability_siege != -1)
}

function IsCityCenter( entityIndex ){
    return (Entities.GetUnitLabel( entityIndex ) == "city_center")
}
