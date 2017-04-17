# **BMD's Lua Unit Colliders Library**
--------------------------------
See [PhysicsReadme.md](https://github.com/bmddota/barebones/blob/source2/PhysicsReadme.md) for documentation and examples on using Physics/Motion controls.

#### **How to install:**
- Drop physics.lua in with your vscripts
- Add require( 'physics' ) somewhere in your lua instantiation path

#### **How to use:**
- The colliders system can operate on regular units and Physics-units (though can only operate on Physics-units in some noted cases)
- Colliders are constructed out of collider tables, of which several profiles are provided with this library (and more can be created)
- Colliders are one of 3 primary types, COLLIDER_SPHERE, COLLIDER_BOX, or COLLIDER_AABOX
  - COLLIDER_SPHERE collides with units in a sphere around the cnter and can be attached to a unit (the collider center will follow its position).
  - COLLIDER_BOX is a rectangular box collider which does not need to be aligned with the X/Y axes.
  - COLLIDER_AABOX is a rectangular box collider which must be aligned with the X/Y axes.  These are generally far cheaper than COLLIDER_BOX.
- Colliders can be expensive.  Pay close attention to the .filter and .test properties of each collider in order to improve performance.
- The easiest way to jump in with colliders is to check out the Collider Profiles and Examples sections


**Colliders Library Functions**
=============================
#### **Physics:AddCollider([name,] collider)**
  This function is used for creating a collider without a profile without being tied to any particular unit.  The "name" parameter is optional, but must be unique if given.  Collider follows the standard collider format as given in the Collider Format section.  Returns the registered collider for additional modification/reference.

#### **Physics:ColliderFromProfile(profileName[, collider])**
  This function is used to create a new collider from the given collider profile name.  The profile name must match a registered profile.  Returns a copy of the collider profile modified with the properties passed in for the 'collider' table if given.

#### **Physics:CreateColliderProfile(profileName, profile)**
  This function is used to create and register a new collider profile for the given profile name.  This registered collider profile can then be used to create new colliders using the profile collider table as a base.

#### **Physics:RemoveCollider(name)**
  This function removes a collider by name from the Physics API so that it is no longer processed.


**PhysicsUnit Functions**
=============================
A unit which has been converted to a Physics Unit can have a collider attached to it and managed using the following functions:

#### **AddCollider([name,] collider)**
  This function can be called to add a collider (in the correct Collider Format) to the unit.  An optional name can be given, or a unique name will be used.  The resulting collider will be returned for further adjustment/management.

#### **AddColliderFromProfile([name,] profile, [collider])**
  This function can be called to add a collider from a registered collider profile to this unit.  The profile must be provided, as can an optional name or collider properties table.  The resulting collider will be returned for further adjustment/management.

#### **GetColliders()**
  Returns a table of all colliders attached to this unit in {name=colliderTable} format.

#### **GetMass()**
  Returns the mass of this unit for use in "momentum" collider calculations.  The default mass is set to 100.

#### **RemoveCollider(name)**
  This function can be called to remove a collider by name from this unit.  The collider will also be removed from the Physics API.

#### **SetMass(mass)**
  Sets the mass of this unit for use in "momentum" collider calculations.



**Collider Table Format**
=============================
Colliders are effectively a formatted lua table which is registered with the Physics API for processing and action.  All collider tables have the following properties and functions, though individual colliders can have additional properties/functions in order to support their actions:

### **COLLIDER_SPHERE Type**
| Property  | Description |
| :------------ | :-----|
| draw      | Whether to DebugDraw the collider for visual confirmation.  Additionally, a table can be provided with color and alpha properties. | 
| filter      | An optional table of entities which will be checked by the collider system.  If left nil all entities within possible range will be checked.| 
| name       | The unique string used as a registration reference for this collider
| radius      | The radius within which to detect and test entities for collision | 
| skipFrames      | The number of frames to skip between tests.  Each frame is 33 milliseconds delay.  Defaults to 0 (30 checks per second) | 
| skipOffset | Advanced property used to space out colliders with skipFrames.  Automatically set by Physics API. | 
| type | COLLIDER_SPHERE, COLLIDER_BOX, or COLLIDER_AABOX | 


| Functions  | Parameters | Description |
| :------------ | :---------| :-----|
| action      | colliderTable, colliderUnit, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called after the preaction has run.  Actual unit motion processing is done here for built-in profiles. |
| filter      | colliderTable | An optional function which should return a table of entities to check.  If left nil all entities within possible range will be checked. |
| preaction      | colliderTable, colliderUnit, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called before the action.  Use this function to add a pre-motion action to built-in profiles. |
| postaction      | colliderTable, colliderUnit, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called after the action.  Use this function to add a post-motion action to built-in profiles. |
| test      | colliderTable, colliderUnit, collidedUnit | Called when a unit is found within the collider range to test for matching the collider criteria.  This function should return true if the collider should interact with the colliding unit, and false if not. |


### **COLLIDER_BOX/COLLIDER_AABOX Type**

| Property  | Description |
| :------------ | :-----|
| box      | The definition of the box used in BOX and AABOX type colliders.  For AABOX this is a table of two vectors defining the x,y,z mins and maxs.  For BOX this is a table of three vectors defining a diagonal triangle across the box.  See Physics:CreateBox().|
| draw      | Whether to DebugDraw the collider for visual confirmation.  Additionally, a table can be provided with color and alpha properties. | 
| filter      | An optional table of entities which will be checked by the collider system.  If left nil all entities within possible range will be checked.| 
| name       | The unique string used as a registration reference for this collider |
| recollideTime | The amount of gametime to prevent a recollision with this collider by any given unit.  Generally 0. |
| skipFrames      | The number of frames to skip between tests.  Each frame is 33 milliseconds delay.  Defaults to 0 (30 checks per second) | 
| skipOffset | Advanced property used to space out colliders with skipFrames.  Automatically set by Physics API. | 
| type | COLLIDER_SPHERE, COLLIDER_BOX, or COLLIDER_AABOX | 


| Functions  | Parameters | Description |
| :------------ | :---------| :-----|
| action      | colliderTable, boxDefinition, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called after the preaction has run.  Actual unit motion processing is done here for built-in profiles. |
| filter      | colliderTable | An optional function which should return a table of entities to check.  If left nil all entities within possible range will be checked. |
| preaction      | colliderTable, boxDefinition, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called before the action.  Use this function to add a pre-motion action to built-in profiles. |
| postaction      | colliderTable, boxDefinition, collidedUnit | Called when a unit has been found within the collider and has passed the filter and test.  Called after the action.  Use this function to add a post-motion action to built-in profiles. |
| test      | colliderTable, boxDefinition, collidedUnit | Called when a unit is found within the collider range to test for matching the collider criteria.  This function should return true if the collider should interact with the colliding unit, and false if not. |
  

**Built-in Collider Profiles**
=============================
## **COLLIDER_SPHERE**

### **blocker**
A blocker collider blocks out either the colliding unit or the collider-attached unit whenever a successful collision is found.  Can affect non-Physics units.

| Property  | Description |
| :------------ | :-----|
| buffer      | Additional distance beyond the collider radius to block units out that collide with this collider.  Defaults to 0.|
| findClearSpace      | Whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| moveSelf      | If set to true, this collider will move the attached unit instead of the colliding unit. Defaults to false.| 


### **delete**
A delete collider deletes the colliding unit or the collider-attached unit whenever a successful collision is found.  Can affect non-Physics units.

| Property  | Description |
| :------------ | :-----|
| deleteSelf      | If set to true, this collider will delete the attached unit instead of the colliding unit.  Defaults to true.|
| removeCollider      | When this collider successfully collides with a unit, immediately remove it so as to prevent further collisions.  Defaults to true. | 


### **gravity**
A gravity collider applies a force to any colliding unit attracting it towards the collider-attached unit with a given force and function.

| Property  | Description |
| :------------ | :-----|
| force      | The amount of force/velocity in hammer units per second to apply to a colliding unit within the full-effect radius of this collider. Default is 1000.|
| fullRadius      | The radius to use as the full effect radius at which point full force is applied.  Defaults to 0.  Must be less than the radius. | 
| linear      | Whether this collider should use a linear gravity force falloff between the fullRadius and radius.  If set to false, uses standard quadratic falloff. Default is false.|
| minRadius      | The radius to use for when a colliding unit is too close to the attached unit and should receive 0 gravitational force. An "eye-of-the-storm" radius. Default is 0.|


### **repel**
A repel collider applies a force to any colliding unit repelling it away from the collider-attached unit with a given force and function.

| Property  | Description |
| :------------ | :-----|
| force      | The amount of force/velocity in hammer units per second to apply to a colliding unit within the full-effect radius of this collider. Default is 1000.|
| fullRadius      | The radius to use as the full effect radius at which point full force is applied.  Defaults to 0.  Must be less than the radius. | 
| linear      | Whether this collider should use a linear repulsion force falloff between the fullRadius and radius.  If set to false, uses standard quadratic falloff. Default is false. |
| minRadius      | The radius to use for when a colliding unit is too close to the attached unit and should receive 0 repulsion force. An "eye-of-the-storm" radius. Default is 0.|


### **reflect**
A reflect collider applies a reflection force using the incident vector of collision with the collider sphere to redirect the velocity of the colliding unit.  Additionally can act as a blocker.

| Property  | Description |
| :------------ | :-----|
| block | Whether this collider should also act as a blocker for units.  Defaults to true.|
| blockRadius      | If blocking, the radius from the collider-attached unit from which to begin blocking units.  Defaults to 100.|
| buffer      | If blocking, the additional distance beyond the collider radius to block units out that collide with this collider.  Defaults to 0.|
| findClearSpace      | If blocking, whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| moveSelf      | If blocking and set to true, this collider will move the attached unit instead of the colliding unit. Defaults to false.| 
| multiplier | The scalar multiplier to apply to the incident vector velocity to create the reflecting force.  Defaults to 1.0|


### **momentum**
A momentum collider applies a force to the colliding unit and collider-attached unit in accordance with their mass as set on their Physics Unit settings.  The elasticity coefficient of the collision can be set.  Additionally can act as a blocker.

| Property  | Description |
| :------------ | :-----|
| block | Whether this collider should also act as a blocker for units.  Defaults to true.|
| blockRadius      | If blocking, the radius from the collider-attached unit from which to begin blocking units.  Defaults to 100.|
| buffer      | If blocking, the additional distance beyond the collider radius to block units out that collide with this collider.  Defaults to 0.|
| elasticity | The elasticity of the collision mediated by this collider. A setting of 1 means a fully elastic collision, while a setting of 0 means a fully inelastic collision.  If two momentum colliders collide, a setting of 0 will result in an elastic collision after both colliders process the collision. Defaults to 1.|
| findClearSpace      | If blocking, whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| moveSelf      | If blocking and set to true, this collider will move the attached unit instead of the colliding unit. Defaults to false.| 

### **momentumFull**
A momentumFull collider applies a force to the colliding unit and collider-attached unit in accordance with their mass as set on their Physics Unit settings.  MomentumFull differs from a standard momentum collider by ensuring that full force is always transferred regardless of the angle.  The elasticity coefficient of the collision can be set.  Additionally can act as a blocker.

| Property  | Description |
| :------------ | :-----|
| block | Whether this collider should also act as a blocker for units.  Defaults to true.|
| blockRadius      | If blocking, the radius from the collider-attached unit from which to begin blocking units.  Defaults to 100.|
| buffer      | If blocking, the additional distance beyond the collider radius to block units out that collide with this collider.  Defaults to 0.|
| elasticity | The elasticity of the collision mediated by this collider. A setting of 1 means a fully elastic collision, while a setting of 0 means a fully inelastic collision.  If two momentum colliders collide, a setting of 0 will result in an elastic collision after both colliders process the collision. Defaults to 1.|
| findClearSpace      | If blocking, whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| moveSelf      | If blocking and set to true, this collider will move the attached unit instead of the colliding unit. Defaults to false.| 


-----------------------------------
## **COLLIDER_AABOX / COLLIDER_BOX**

### **aaboxblocker** / **boxblocker**
A boxblocker collider blocks out the colliding unit whenever a successful collision is found.  Can affect non-Physics units if 'slide' property is set to false.

| Property  | Description |
| :------------ | :-----|
| buffer      | The additional distance beyond the collider box definition to block units out that collide with this collider.  Defaults to 0.|
| findClearSpace      | Whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| slide      | Whether the colliding Physics Unit should slide along the edge of the box with which it collides. Defaults to true.| 


### **aaboxreflect** / **boxreflect**
A boxreflect collider blocks out the colliding unit whenever a successful collision is found.  

| Property  | Description |
| :------------ | :-----|
| block | Whether this collider should also act as a blocker for units.  Defaults to true.|
| buffer      | The additional distance beyond the collider box definition to block units out that collide with this collider.  Defaults to 0.|
| findClearSpace      | Whether to use FindClearSpaceForUnit to block the colliding unit out.  Defaults to false. | 
| multiplier | The scalar multiplier to apply to the incident vector velocity to create the reflecting force.  Defaults to 1.0|





**Examples:** 
=============================
See [examples/colliders.lua](https://github.com/bmddota/barebones/blob/source2/game/dota_addons/barebones/scripts/vscripts/examples/colliders.lua) for collider examples as demonstrated in [my youtube video](https://www.youtube.com/watch?v=AxBxQIcEMI8).