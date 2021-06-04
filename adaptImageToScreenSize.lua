local adaptImageToScreenSize = {}

-- Pour adapter une image a la taille d'écran actuel du joueur, grâce au scaleX et scaleY (background menu ...)
-- Load : imageScaleX, imageScaleY = getScaling(img)
-- Draw : love.graphics.draw(img, x, y, 0, imageScaleX, imageScaleY)
function adaptImageToScreenSize(image)
	local imgWidth = image:getWidth()
	local imgHeight = image:getHeight()

	local scaleX = largeurEcran / imgWidth
	local scaleY = hauteurEcran / imgHeight

	return scaleX, scaleY
end

return adaptImageToScreenSize