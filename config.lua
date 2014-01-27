application =
{
    content =
    {
        width = 640,
        height = 960,
        scale = "letterbox",
        xAlign = "left",
        yAlign = "top"
    }
}


local aspectRatio = display.pixelHeight / display.pixelWidth

application =
{
  content =
  {
    width = aspectRatio > 1.5 and 800 or math.ceil( 1200 / aspectRatio ),
    height = aspectRatio < 1.5 and 1200 or math.ceil( 800 * aspectRatio ),
    scale = "letterBox", -- zoom to fill screen, possibly cropping edges
    fps = 60,
    antialias = true,
                
    imageSuffix =
    {
      ["@2x"] = 1.3,
    },
  },
}