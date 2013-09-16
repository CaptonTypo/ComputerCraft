term.clear()
term.setCursorPos(1,1)

local run = true

function attack()
local count = 0
	while run == true do
		turtle.attack()
		count = count + 1
		if count > 500 then
			dropLoot()
		end
	end
end

function dropLoot()
	local dropItem = 1
	repeat
		turtle.select(dropItem)
		turtle.drop()
		dropItem = dropItem + 1
	until dropItem > 16
	attack()
end

print("Running attack program.")
attack()