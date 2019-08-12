display.setDefault( "textureWrapX", "repeat" )

local background = display.newRect(190, 160, 580, 270)
background.fill = {type = "image", filename = "image/Background.png" }

local middleground = display.newRect(display.contentCenterX, 200, 580, 216)
middleground.fill = {type = "image", filename = "image/Middleground.png" }

local floor = display.newRect(190, 295, 580, 45)
floor.fill = {type = "image", filename = "image/floor.jpg" }

local grama = display.newRect(190, 173, 580, 216)
grama.fill = {type = "image", filename = "image/grama.png" }

--configuramos largura e altura dos sprites, bem como o nro. deles
local sheetOptions = { width = 50, height = 37, numFrames = 6 }
--carregamos a spritesheet com as opções
local sheet = graphics.newImageSheet( "image/run.png", sheetOptions )

--definimos uma animação (sequence)
local sequences = {
    {
        name = "normalRun",
        start = 1,
        count = 6,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}

--criamos um objeto de display com todas as configs anteriores
local running = display.newSprite( sheet, sequences )

--posicionamos o objeto na tela
running.x = display.contentWidth / 5
running.y = 245
running.xScale = 1.2
running.yScale = 1.2

--manda rodar
running.isVisible = false;

local sheetOptionsStop = { width = 50, height = 37, numFrames = 4 }

local sheetStop = graphics.newImageSheet( "image/stopped.png", sheetOptionsStop )

local sequenceStop = {
    {
        name = "normalStop",
        start = 1,
        count = 4,
        time = 500,
        loopCount = 0,
        loopDirection = "forward"
    }
}
 
local waiting = display.newSprite( sheetStop, sequenceStop )
waiting.x = display.contentWidth / 5
waiting.y = 245--distância do cavalo ao chão
waiting.xScale = 1.2
waiting.yScale = 1.2

local sequencesJump = {
    {
        name = "jump",
        start = 1,
        count = 4,
        time = 500,
        loopCount = 1,
        loopDirection = "forward"
    }
}

local sheetOptionsJump = { width = 50, height = 37, numFrames = 4 }
local sheetJump = graphics.newImageSheet( "image/jump.png", sheetOptionsJump )

local jumping = display.newSprite( sheetJump, sequencesJump )
jumping.x = display.contentWidth / 5
jumping.y = 225--distância do cavalo ao chão
jumping.xScale = 1.2
jumping.yScale = 1.2
jumping.isVisible = false;

local function pulo(event)
	if (event.isShake == true) then
	waiting.isVisible = false;
	running.isVisible = false;
	jumping.isVisible = true;
	jumping:setSequence("jump")
	jumping:play()
	end
   end
   
   local function fimPulo(event)
	if (event.phase == "ended") then
	waiting.isVisible = false;
	running.isVisible = true;
	running:setSequence("normalRun")
	running:play()
	jumping:pause();
	jumping.isVisible = false;
	end
   end
   
   Runtime:addEventListener("accelerometer", pulo);
   jumping:addEventListener("sprite", fimPulo);

--função de início

local function animateBackground()
	transition.to( background.fill, { time=15000, x=1, delta=true, onComplete=
    transition.to( middleground.fill, { time=15000, x=1, delta=true, onComplete=
    transition.to( floor.fill, { time=15000, x=1, delta=true, onComplete=
    transition.to( grama.fill, { time=15000, x=1, delta=true, onComplete=animateBackground } ) } ) } ) } ) 
end

--função de início
local function start(event)
    waiting.isVisible = false;
    running.isVisible = true;
    running:setSequence("normalRun")
	running:play()
	animateBackground();
end
   
local function stop(event)
	waiting.isVisible = true;
	running.isVisible = false;
	running:pause()
	transition.cancel();
end

running:addEventListener("tap", stop);
waiting:addEventListener("tap", start);
