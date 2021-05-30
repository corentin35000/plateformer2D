local animationsParticulesFXEffets = {}

-- Une table qui contient toutes les Spritesheets des animations de Particules/FX/Effets..
local SpriteSheetsParticulesFX = {}

-- Tableau à deux dimensions contenant toute les animations de Particules/FX/Effets..
animationsParticulesFX = {}




function animationsParticulesFXEffets.Load()
    -- animationsParticulesFX['nomAnimation'] = decoupeSpriteSheet(0, 0, imgWidth, imgHeight, 8, 14, 2, imgTileSheet)
    -- Creer la propriétée animationsParticulesFX.frames pour changer d'image dynamiquement
end

function animationsParticulesFXEffets.Update()
 
end

function animationsParticulesFXEffets.Draw()
    --local frameArrondie = math.floor(animationsParticulesFX.frames)
    --love.graphics.draw(imgSpriteSheet, animationsParticulesFX['nomAnimation'][frameArrondie], x, y)
end

return animationsParticulesFXEffets