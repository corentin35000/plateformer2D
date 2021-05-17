local splashscreen = {}


function splashscreen.Update()
  
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


return splashscreen