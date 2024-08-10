local inputVars = {}
inputVars.w = false
inputVars.wLock = false
inputVars.a = false
inputVars.aLock = false
inputVars.s = false
inputVars.sLock = false
inputVars.d = false
inputVars.dLock = false
inputVars.e = false
inputVars.eLock = false
inputVars.r = false
inputVars.rLock = false
inputVars.space = false
inputVars.spaceLock = false
inputVars.lmb = false
inputVars.lmbLock = false
inputVars.mmb = false
inputVars.mmbLock = false
inputVars.rmb = false
inputVars.rmbLock = false

local inputLib = {
    handleW = function()
        if input.IsKeyDown(KEY_W) == true and inputVars.wLock == false then
            if inputVars.w == false then
                inputVars.w = true
            elseif inputVars.w == true then
                inputVars.w = false
                inputVars.wLock = true
            end
        end

        if input.IsKeyDown(KEY_W) == false and inputVars.wLock == true then
            inputVars.wLock = false
        end
    end,
    handleA = function()
        if input.IsKeyDown(KEY_A) == true and inputVars.aLock == false then
            if inputVars.a == false then
                inputVars.a = true
            elseif inputVars.a == true then
                inputVars.a = false
                inputVars.aLock = true
            end
        end

        if input.IsKeyDown(KEY_A) == false and inputVars.aLock == true then
            inputVars.aLock = false
        end
    end,
    handleS = function()
        if input.IsKeyDown(KEY_S) == true and inputVars.sLock == false then
            if inputVars.s == false then
                inputVars.s = true
            elseif inputVars.s == true then
                inputVars.s = false
                inputVars.sLock = true
            end
        end

        if input.IsKeyDown(KEY_S) == false and inputVars.sLock == true then
            inputVars.sLock = false
        end
    end,
    handleD = function()
        if input.IsKeyDown(KEY_D) == true and inputVars.dLock == false then
            if inputVars.d == false then
                inputVars.d = true
            elseif inputVars.d == true then
                inputVars.d = false
                inputVars.dLock = true
            end
        end

        if input.IsKeyDown(KEY_D) == false and inputVars.dLock == true then
            inputVars.dLock = false
        end
    end,
	handleE = function()
        if input.IsKeyDown(KEY_E) == true and inputVars.eLock == false then
			if inputVars.e == false then
				inputVars.e = true
			elseif inputVars.e == true then
				inputVars.e= false
				inputVars.eLock = true
			end
		end
				
		if input.IsKeyDown(KEY_E) == false and inputVars.eLock == true then
			inputVars.eLock = false
		end
    end,
    handleR = function()
        if input.IsKeyDown(KEY_R) == true and inputVars.rLock == false then
            if inputVars.r == false then
                inputVars.r = true
            elseif inputVars.r == true then
                inputVars.r = false
                inputVars.rLock = true
            end
        end

        if input.IsKeyDown(KEY_R) == false and inputVars.rLock == true then
            inputVars.rLock = false
        end
    end,
    handleSpace = function()
        if input.IsKeyDown(KEY_SPACE) == true and inputVars.spaceLock == false then
            if inputVars.space == false then
                inputVars.space = true
            elseif inputVars.space == true then
                inputVars.space = false
                inputVars.spaceLock = true
            end
        end

        if input.IsKeyDown(KEY_SPACE) == false and inputVars.spaceLock == true then
            inputVars.spaceLock = false
        end
    end,
	handleLMB = function()
		if input.IsMouseDown(MOUSE_LEFT) == true and inputVars.lmbLock == false then
			if inputVars.lmb == false then
				inputVars.lmb = true
			elseif inputVars.lmb == true then
				inputVars.lmb = false
				inputVars.lmbLock = true
			end
		end
		
		if input.IsMouseDown(MOUSE_LEFT) == false and inputVars.lmbLock == true then
			inputVars.lmbLock = false
		end
	end,
    handleMMB = function()
        if input.IsMouseDown(MOUSE_MIDDLE) == true and inputVars.mmbLock == false then
            if inputVars.mmb == false then
                inputVars.mmb = true
            elseif inputVars.mmb == true then
                inputVars.mmb = false
                inputVars.mmbLock = true
            end
        end

        if input.IsMouseDown(MOUSE_MIDDLE) == false and inputVars.mmbLock == true then
            inputVars.mmbLock = false
        end
    end,
    handleRMB = function()
        if input.IsMouseDown(MOUSE_RIGHT) == true and inputVars.rmbLock == false then
            if inputVars.rmb == false then
                inputVars.rmb = true
            elseif inputVars.rmb == true then
                inputVars.rmb = false
                inputVars.rmbLock = true
            end
        end

        if input.IsMouseDown(MOUSE_RIGHT) == false and inputVars.rmbLock == true then
            inputVars.rmbLock = false
        end
    end,
}

local inputGlobalSystems = {}
inputGlobalSystems.mainInputHandler = function(gameObjects, ghfDemoContext)
    ghfDemoContext.inputLib.handleW()
    ghfDemoContext.inputLib.handleA()
    ghfDemoContext.inputLib.handleS()
    ghfDemoContext.inputLib.handleD()
    ghfDemoContext.inputLib.handleE()
    ghfDemoContext.inputLib.handleR()
    ghfDemoContext.inputLib.handleSpace()
    ghfDemoContext.inputLib.handleLMB()
    ghfDemoContext.inputLib.handleMMB()
    ghfDemoContext.inputLib.handleRMB()
end

return inputLib, inputVars, inputGlobalSystems