--0.0.5
--
-- k47 Building Library
-- by k47
-- modified by Kyomujin
--
-- For originals see: pastebin.com/u/ck47
-- See readme for installing modified libraries
-- @ pastebin.com/u/kyomujin
pSlot = 1

function swapInv (a,b)
  turtle.select(a)
  turtle.dropUp() -- Drop contents of a
  turtle.select(b)
  turtle.transferTo(a) -- Move contents of b to a
  turtle.suckUp() -- Pickup up contents fo a
end

function transferItems (a, b)
  fill = math.min(turtle.getItemSpace(b), turtle.getItemCount(a))
  
  turtle.select(a)
  return turtle.transferTo(b, fill)
end

function findMaterials ()
  if pSlot==16 then pSlot=1 end
  
  for s=pSlot+1,16 do
    if turtle.getItemCount (s) > 0 then
      if not turtle.detectDown() or (turtle.detectDown() and turtle.digDown()) then
        turtle.select (s)
        if turtle.placeDown() then
          pSlot=s
          return true
        end
      end
    end
  end
  pSlot=1
  return false
end

function findRefMaterials (slot)
  for s=1,16 do
    turtle.select (s)
    if s == slot then
      if turtle.getItemCount (s) > 1 then
        return true
      end
    elseif turtle.getItemCount (s) > 0 and turtle.compareTo (slot) then
      res = transferItems(s, slot)
      turtle.select(slot)
      --:materials found
      return res
    end --:check if match
  end --:material search
  --:no matching material found
  return false
end

function place ()
  if pSlot==nil then pSlot = 1 end
  
  if turtle.getItemCount (pSlot) == 0 then
    while not findMaterials( ) do
      print ("Need more materials...")
      sleep (5)
    end
  end
  turtle.select (pSlot)
  if turtle.detectDown () then
    turtle.digDown ()
  end
  
  return turtle.placeDown ()
  
end

-- Try to place a block using slot as a referrence
function refPlace (slot)
  if slot==nil then slot = 1 end
  
  while turtle.getItemCount(slot) == 0 do
    print("please put an item in slot: "..slot)
    sleep(5)
  end
  
  turtle.select (slot)
  if turtle.detectDown () then
    if turtle.compareDown () then
      return true
    else
      turtle.digDown ()
    end
  end
  
  if turtle.getItemCount (slot) > 1 then
    turtle.select (slot)
    return turtle.placeDown ()
  else
    --:find more materials
    while not findRefMaterials (slot) do
      print ("Need more materials ....")
      sleep (5)
    end
    
    return turtle.placeDown()  
      
  end --:if refItemCount > 1
end

-- vim: ft=lua ts=2 sts=2 sw=2