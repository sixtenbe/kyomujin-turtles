--0.0.4
--
-- k47 Building Library
-- by k47
-- modified by Kyomujin
--
-- SEE MY README for instructions on installing my libraries
-- @ pastebin.com/u/ck47

slot = 1

function swapInv (a,b)
  turtle.select(a)
  turtle.dropDown() -- Drop contents of a
  turtle.select(b)
  turtle.dropUp() -- Drop contents of slot b
  turtle.suckDown()
  turtle.select(a)
  turtle.suckUp()
  turtle.select(b)
end

function findMaterials ()
  if slot==16 then slot=1 end
  
  for s=slot+1,16 do
    if turtle.getItemCount (s) > 0 then
      if not turtle.detectDown() or (turtle.detectDown() and turtle.digDown()) then
        turtle.select (s)
        if turtle.placeDown() then
          slot=s
          return true
        end
      end
    end
  end
  slot=1
  return false
end

function findRefMaterials ()
  for s=2,16 do
  turtle.select (s)
    if turtle.getItemCount (s) > 0 and turtle.compareTo (slot) then
      if s == slot+1 then
          -- continue
      elseif turtle.getItemSpace (slot) >= turtle.getItemCount (s) then
          -- Adds slot s to slot 1
          turtle.dropDown () -- Drop contents of slot s
          turtle.select (slot)
          turtle.suckDown ()
      else
          -- Swaps slot s with slot 2
          swapInv (s,slot+1)
      end
      --:materials found
      return true
    end --:check if match
  end --:material search
  --:no matching material found
  return false
end

function place ()
  if turtle.getItemCount (slot) == 0 then
    while not findMaterials (slot) do
      print ("Need more materials...")
      sleep (5)
    end
  end
  turtle.select (slot)
  if turtle.detectDown () then
    turtle.digDown ()
  end
  
  return turtle.placeDown ()
  
end

-- Try to place a block using slot 1 as a referrence
function refPlace ()
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
    while not findRefMaterials () do
      print ("Need more materials ....")
      sleep (5)
    end
    
    return turtle.placeDown()  
      
  end --:if refItemCount > 1
end

-- vim: ft=lua ts=2 sts=2 sw=2