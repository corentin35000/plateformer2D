local splashscreen = {}


function splashscreen.Load()

  -- Video SplashScreen for Studio.
  -- La variable video est un Objet, qui contient le SplashScreen du Studio, il prend en parametre un boolean qui prend true si le son de la vidéo doit être activé.
  -- Une variable pour compter la durer de la video et puis ensuite jouer le SplashScreen.
  video = love.graphics.newVideo("video/splashScreenStudio.ogv", {audio = true, dpiscale = 1})
  videoWidth = video:getWidth()
  videoHeight = video:getHeight()
  counterTimeSplashScreen = 0
  video:play()
  
end


function splashscreen.Update(dt)
  
  -- Video SplashScreen for Studio / isPlaying() return true or false -> Obtient si la vidéo est en cours de lecture.
  -- Counter pour la video
  playingVideo = video:isPlaying()
  
  if playingVideo == true then
    counterTimeSplashScreen = counterTimeSplashScreen + 1
  end
  
  -- Cursor non visible lors du SplashScreen
  if playingVideo == true then
    love.mouse.setVisible(false)
  else
    love.mouse.setVisible(true)
  end
  
end


function splashscreen.Draw()

  -- Affichage de la video du SplashScreen
  love.graphics.draw(video, (largeurEcran / 2), (hauteurEcran / 2), 0, 1, 1, (videoWidth / 2), (videoHeight / 2))
  
end


return splashscreen