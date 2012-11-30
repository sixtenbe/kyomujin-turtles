--0.1.0
--
-- Mixing
-- by Kyomujin
--
--
--Code to refill buckets for a factorization mixer
--Requirements for operation:
--Must be an empty bucket in the first slot
--Mixer must be above the turtle
--Water is in front of the turtle
--Chest below the turtle, which sorts items as needed
--
--To interupt program place a block in front of the turtle

local buckets = 1

function bucketFill(n)
  if n==nil then n=1 end
  for j=1, n do
    turtle.place()
    --sleep to allow water to regen
    os.sleep(0.5)
  end
end


--only run if no block in front
while not turtle.detect() do
  print("fill buckets")
  --get items from invent
  turtle.select(1)
  while turtle.suckUp() do
    --pass
  end
  
  
  --check if there any buckets in slots 2-16
  
  for i=2, 16, 1 do
    turtle.select(i)
    if turtle.compareTo(1) then
      buckets = turtle.getItemCount(i)
      print(string.format("%d buckets", buckets))
      
      --fill buckets
      bucketFill(buckets)
      turtle.select(i)
      turtle.dropDown(i)
    end --if found bucket
  end --find buckets
  
  --check if more buckets exist in slot 1
  turtle.select(1)
  buckets = turtle.getItemCount(1)
  if buckets > 1 then
    bucketFill(buckets - 1)
  end
  
  --empty inventory
  for j=2, 16 do
    turtle.select(j)
    turtle.dropDown()
  end
  turtle.select(1)
  
  
  
  --mixing takes 24 sec
  os.sleep(20)
  
end  --while loop