if hero == nil then
  hero = PlayerResource:GetPlayer(0):GetAssignedHero()
  Physics:Unit(hero)
end

--[[if true then
  boxcollider4 = Physics:AddCollider("aabox2", Physics:ColliderFromProfile("aaboxreflect"))
  boxcollider4.box = {Vector(-400,-800,0), Vector(-200,-200,500)}
  boxcollider4.draw = true
  boxcollider4.test = function(self, unit)
    return IsPhysicsUnit(unit)
  end
  return
end]]

if testCount == nil then
  if not enigma then
    enigma = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), true, hero, hero, hero:GetTeamNumber())
    enigma:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
    enigma:SetModel('models/heroes/enigma/enigma.vmdl')
    enigma:SetOriginalModel('models/heroes/enigma/enigma.vmdl')

    Physics:Unit(enigma)

    planet1 = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), true, hero, hero, hero:GetTeamNumber())
    planet1:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
    planet1:SetModel('models/props_gameplay/rune_doubledamage01.vmdl')
    planet1:SetOriginalModel('models/props_gameplay/rune_doubledamage01.vmdl')
    Physics:Unit(planet1)


    planet2 = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), true, hero, hero, hero:GetTeamNumber())
    planet2:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
    planet2:SetModel('models/props_gameplay/rune_haste01.vmdl')
    planet2:SetOriginalModel('models/props_gameplay/rune_haste01.vmdl')
    Physics:Unit(planet2)

    planet3 = CreateUnitByName('npc_dummy_unit', Vector(0,0,0), true, hero, hero, hero:GetTeamNumber())
    planet3:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
    planet3:SetModel('models/props_gameplay/rune_illusion01.vmdl')
    planet3:SetOriginalModel('models/props_gameplay/rune_illusion01.vmdl')
    Physics:Unit(planet3)
  end

  Timers:CreateTimer(function()
    enigma:SetAbsOrigin(Vector(0,0,400))

    enigma:RemoveCollider()
    collider = enigma:AddColliderFromProfile("gravity")
    collider.radius = 1000
    collider.fullRadius = 0
    collider.force = 5000
    collider.linear = false
    collider.test = function(self, collider, collided)
      return IsPhysicsUnit(collided) and collided.GetUnitName and collided:GetUnitName() == "npc_dummy_unit"
    end

    planet1:SetAbsOrigin(Vector(-500,0,400))
    planet2:SetAbsOrigin(Vector(300,0,400))
    planet3:SetAbsOrigin(Vector(0,100,400))

    planet1:SetPhysicsVelocity(Vector(0,600,0))
    planet2:SetPhysicsVelocity(Vector(0,0,1000))
    planet3:SetPhysicsVelocity(Vector(1,0,1):Normalized() * 1200)
    planet1:SetPhysicsFriction(0)
    planet2:SetPhysicsFriction(0)
    planet3:SetPhysicsFriction(0)
  end)

  testCount = -1
end

-- Default block others
if testCount == 0 then
  enigma:RemoveSelf()
  planet1:RemoveSelf()
  planet2:RemoveSelf()
  planet3:RemoveSelf()
  if testUnit == nil then
    --PrecacheUnitByNameAsync("npc_dota_hero_slark", function(...) end)
    testUnit = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
    testUnit:SetModel('models/heroes/viper/viper.vmdl')
    testUnit:SetOriginalModel('models/heroes/viper/viper.vmdl')

    testUnit:SetControllableByPlayer(0, true)
    Physics:Unit(testUnit)

    ring = nil
    ring2 = nil
    ring3 = nil
    ring4 = nil
    ring5 = nil
    ring6 = nil

    box1 = nil
    box2 = nil
    box3 = nil

    mass = 100
  end

  if testUnit2 == nil then
    --PrecacheUnitByNameAsync("npc_dota_hero_slark", function(...) end)
    testUnit2 = CreateUnitByName('npc_dummy_blank', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
    --testUnit2:SetModel('models/heroes/viper/viper.vmdl')
    --testUnit2:SetOriginalModel('models/heroes/viper/viper.vmdl')
    testUnit2:SetModel('models/heroes/abaddon/abaddon.vmdl')
    testUnit2:SetOriginalModel('models/heroes/abaddon/abaddon.vmdl')

    testUnit2:SetControllableByPlayer(0, true)
    testUnit2:SetRenderColor(200,0,0)
    Physics:Unit(testUnit2)
  end

  --ring = {unit = hero, radius = 500, alpha = 0, rgb = Vector(50,50,200)}
  --ring2 = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(50,200,50)}
  --ring3 = {unit = hero, radius = 1500, alpha = 0, rgb = Vector(200,50,50)}

  collider = hero:AddColliderFromProfile("blocker")
  collider.radius = 400
  collider.draw = {color = Vector(200,200,200), alpha = 5}

  ring = {unit = hero, radius = 400, alpha = 0, rgb = Vector(200,50,50)}

  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
  collider.postaction = function(self, collider, collided)
    print("post: " .. collided:GetName() .. " -- " .. VectorDistance(collider:GetAbsOrigin(), collided:GetAbsOrigin()))
  end
  collider.preaction = function(self, collider, collided)
    print("pre: " .. collided:GetName() .. " -- " .. VectorDistance(collider:GetAbsOrigin(), collided:GetAbsOrigin()))
  end


  Physics:RemoveCollider("testbox")
  boxcollider = Physics:AddCollider("testbox", Physics:ColliderFromProfile("boxblocker"))
  boxcollider.box = {Vector(-200,0,0), Vector(0,0,0), Vector(-200,1000,500)}
  boxcollider.test = function(self, unit)
    return IsPhysicsUnit(unit)
  end
  box1 = {origin = Vector(0,0,0), min = Vector(-200,0,128), max = Vector(0,1000,180), direction = Vector(1,0,0), alpha = 5, rgb = Vector(50,200,50)}
  units = {}
  --[[for i=1,4 do
    units[i] = CreateUnitByName('npc_dummy_unit', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
    --units[i]:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
    units[i]:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
    units[i]:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")
    units[i]:AddNewModifier(units[i], nil, "modifier_phased", {})
  end]]

  Physics:RemoveCollider("testbox2")
  boxcollider2 = Physics:AddCollider("testbox2", Physics:ColliderFromProfile("boxreflect"))
  boxcollider2.box = {Vector(-100,700,0), Vector(1000,700,0), Vector(-100,900,500)}
  boxcollider2.test = function(self, unit)
    return IsPhysicsUnit(unit)
  end
  box2 = {origin = Vector(0,0,0), min = Vector(-100,700,128), max = Vector(1000,900,180),  direction = Vector(1,0,0), alpha = 5, rgb = Vector(200,50,200)}
end

-- Self-blocker
if testCount == 1 then
  collider.moveSelf = true
  ring2 = {unit = testUnit, radius = 400, alpha = 0, rgb = Vector(200,50,200)}
  ring3 = {unit = testUnit2, radius = 400, alpha = 0, rgb = Vector(200,50,200)}

  boxcollider2.draw = true
  boxcollider.draw = {color = Vector(200,200,200), alpha = 5}
end

-- Half radius
if testCount == 2 then
  collider.radius = 200
  collider.draw = true
  ring.radius = 200
  ring2.radius = 200
  ring3.radius = 200
end

--testCount = 3
-- Remove collider, new collider
if testCount == 3 then
  ring = nil
  ring2.radius = 100
  ring2.rgb = Vector(50,50,200)
  ring3 = nil
  ring6 = {unit = testUnit2, radius = 100, alpha = 0, rgb = Vector(50,50,200)}
  hero:RemoveCollider()
  Timers:CreateTimer("timer", {
    callback = function()
      local unit = CreateUnitByName('npc_dummy_unit', hero:GetAbsOrigin() + hero:GetForwardVector() * 100, true, hero, hero, hero:GetTeamNumber())
      unit:FindAbilityByName("reflex_dummy_unit"):SetLevel(1)
      unit:SetModel("models/props_gameplay/rune_doubledamage01.vmdl")
      unit:SetOriginalModel("models/props_gameplay/rune_doubledamage01.vmdl")

      unit:AddNewModifier(unit, nil, "modifier_phased", {})

      Physics:Unit(unit)
      unit:SetMass(mass)
      local projCollider = unit:AddColliderFromProfile("delete")
      projCollider.radius = 100
      projCollider.test = function(self, collider, collided)
        return IsPhysicsUnit(collided) and collided.GetUnitName ~= nil and collided:GetUnitName() == "npc_dummy_blank"
      end

      --unit:SetPhysicsVelocityMax(1000)

      unit:SetFriction(0)
      unit:AddPhysicsVelocity(hero:GetForwardVector() * 3000)
      unit:OnPhysicsFrame(function(unit)
        local dir = testUnit:GetAbsOrigin() - unit:GetAbsOrigin()
        dir = dir:Normalized()

        unit:SetPhysicsAcceleration(dir * 3000)
        end)
      return 1
    end
    })
end

if testCount == 4 then
  Physics:RemoveCollider("testbox")
  boxcollider = Physics:AddCollider("testbox", Physics:ColliderFromProfile("boxreflect"))
  boxcollider.box = {Vector(-100,550,0), 
    RotatePosition(Vector(-100,550,0), QAngle(0,-15,0), Vector(-100,350,0)), 
    RotatePosition(Vector(-100,550,0), QAngle(0,-15,0), Vector(1000,550,0)) + Vector(0,0,500)}
  boxcollider.test = function(self, unit)
    return IsPhysicsUnit(unit)
  end
  boxcollider.draw = {color = Vector(200,200,200), alpha = 5}
  --[[

  Timers:CreateTimer(1, function() 
    units[1]:SetAbsOrigin(boxcollider.box.a + Vector(0,0,200))
    units[1]:SetRenderColor(250,0,0)
    units[2]:SetAbsOrigin(boxcollider.box.b + Vector(0,0,200))
    units[2]:SetRenderColor(250,250,0)
    units[3]:SetAbsOrigin(boxcollider.box.c + Vector(0,0,200))
    units[3]:SetRenderColor(0,0,250)
    units[4]:SetAbsOrigin(boxcollider.box.d + Vector(0,0,200))
    units[4]:SetRenderColor(0,250,0)

    end)]]
  box1 = {origin = Vector(-135,0,0), min = Vector(-100,350,128), max = Vector(1000,550,180),  direction = RotatePosition(Vector(0,0,0), QAngle(0,-15,0), Vector(1,0,0)), alpha = 5, rgb = Vector(200,50,200)}
end

if testCount == 5 then
  collider = hero:AddColliderFromProfile("blocker")
  ring = {unit = hero, radius = 400, alpha = 0, rgb = Vector(200,50,50)}

  collider.radius = 400
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 6 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(200,50,200)}
  collider = hero:AddColliderFromProfile("gravity")
  collider.radius = 1000
  collider.force = 1000
  collider.linear = false
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end
if testCount == 7 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(200,50,200)}
  ring3 = {unit = hero, radius = 500, alpha = 0, rgb = Vector(100,50,200)}
  collider = hero:AddColliderFromProfile("gravity")
  collider.radius = 1000
  collider.fullRadius = 500
  collider.force = 1000
  collider.linear = true
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 8 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 1500, alpha = 0, rgb = Vector(200,50,200)}
  ring3 = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(100,50,200)}
  ring4 = {unit = hero, radius = 750, alpha = 0, rgb = Vector(50,200,50)}
  collider = hero:AddColliderFromProfile("gravity")
  collider.radius = 1500
  collider.fullRadius = 1000
  collider.minRadius = 750
  collider.force = 1000
  collider.linear = true
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 9 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(200,200,50)}
  ring3 = nil
  ring4 = nil
  collider = hero:AddColliderFromProfile("repel")
  collider.radius = 1000
  collider.force = 1000
  collider.linear = false
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 10 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 200, alpha = 0, rgb = Vector(200,200,200)}
  collider = hero:AddColliderFromProfile("reflect")
  collider.radius = 200
  collider.multiplier = 1
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 11 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 200, alpha = 0, rgb = Vector(50,200,50)}
  ring3 = {unit = hero, radius = 100, alpha = 20, rgb = Vector(0,0,0)}
  collider = hero:AddColliderFromProfile("momentum")
  collider.radius = 200
  collider.blockRadius = 100
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 12 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 200, alpha = 0, rgb = Vector(50,200,50)}
  ring3 = {unit = hero, radius = 200, alpha = 20, rgb = Vector(0,0,0)}
  collider = hero:AddColliderFromProfile("momentum")
  collider.radius = 200
  collider.blockRadius = 200
  collider.test = function(self, collider, collided)
  mass = 5
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 13 then
  hero:RemoveCollider()
  collider = hero:AddColliderFromProfile("momentum")
  collider.radius = 200
  collider.blockRadius = 200
  collider.elasticity = 0
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 14 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 200, alpha = 0, rgb = Vector(50,200,50)}
  ring3 = nil
  collider = hero:AddColliderFromProfile("momentum")
  collider.radius = 200
  collider.blockRadius = 0
  collider.elasticity = 0
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end

if testCount == 15 then
  hero:RemoveCollider()
  ring = {unit = hero, radius = 1500, alpha = 0, rgb = Vector(200,50,200)}
  ring3 = {unit = hero, radius = 1000, alpha = 0, rgb = Vector(100,50,200)}
  ring4 = {unit = hero, radius = 750, alpha = 0, rgb = Vector(50,200,50)}
  ring5 = {unit = hero, radius = 400, alpha = 20, rgb = Vector(0,0,0)}
  collider = hero:AddColliderFromProfile("gravity")
  collider.radius = 1500
  collider.fullRadius = 1000
  collider.minRadius = 750
  collider.force = 1000
  collider.linear = true
  collider.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end

  collider2 = hero:AddColliderFromProfile("blocker")
  collider2.radius = 400
  collider2.test = function(self, collider, collided)
    return IsPhysicsUnit(collided) or (collided.IsRealHero and collided:IsRealHero())
  end
end


print(testCount)
testCount = testCount + 1

--PrintTable(Physics.Colliders)

print('0----0')
--print(testUnit:GetModelRadius())
--print(testUnit:BoundingRadius2D())
--print(testUnit:GetHullRadius())
--print(testUnit:GetPaddedCollisionRadius())
PrintTable(Physics.Colliders)
print('0----0')

hero:Hibernate(false)

Timers:RemoveTimer("asdf")
Timers:CreateTimer("asdf", {callback = function()
  if ring ~= nil then
    --DebugDrawSphere(ring.unit:GetAbsOrigin(), Vector(50,200,50), 10, 500, true, .05)
    DebugDrawCircle(ring.unit:GetAbsOrigin(), ring.rgb, ring.alpha, ring.radius, true, .01)
    --Circle(Vector a, Quaternion b, float c, int d, int e, int f, int g, bool h, float i)
  end
  if ring2 ~= nil then
    DebugDrawCircle(ring2.unit:GetAbsOrigin(), ring2.rgb, ring2.alpha, ring2.radius, true, .01)
  end
  if ring3 ~= nil then
    DebugDrawCircle(ring3.unit:GetAbsOrigin(), ring3.rgb, ring3.alpha, ring3.radius, true, .01)
  end
  if ring4 ~= nil then
    DebugDrawCircle(ring4.unit:GetAbsOrigin(), ring4.rgb, ring4.alpha, ring4.radius, true, .01)
  end
  if ring5 ~= nil then
    DebugDrawCircle(ring5.unit:GetAbsOrigin(), ring5.rgb, ring5.alpha, ring5.radius, true, .01)
  end
  if ring6 ~= nil then
    DebugDrawCircle(ring6.unit:GetAbsOrigin(), ring6.rgb, ring6.alpha, ring6.radius, true, .01)
  end

  if box1 ~= nil then
    --DebugDrawBox(box1.origin, box1.min, box1.max, box1.rgb.x, box1.rgb.y, box1.rgb.z, box1.alpha, .01)
    DebugDrawBoxDirection(box1.origin, box1.min, box1.max, box1.direction, box1.rgb, box1.alpha, .01)
  end
  if box2 ~= nil then
    DebugDrawBoxDirection(box2.origin, box2.min, box2.max, box2.direction, box2.rgb, box2.alpha, .01)
  end
  if box3 ~= nil then
    DebugDrawBox(box3.origin, box3.min, box3.max, box3.rgb.x, box3.rgb.y, box3.rgb.z, box3.alpha, .01)
  end
  return .01
end})

--print(VectorDistance(hero:GetAbsOrigin(), testUnit:GetAbsOrigin()))
--print(VectorDistance(hero:GetAbsOrigin(), testUnit:GetAbsOrigin()))