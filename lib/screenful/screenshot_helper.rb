require 'RMagick'
require 'calabash-cucumber'

include Magick

def capture_element( selector, filepath )
    check_element_exists( selector )
    frame = frankly_map( selector, "accessibilityFrame" )[0]
    region = [frame["origin"]["x"],frame["origin"]["y"],frame["size"]["width"],frame["size"]["height"]].join('.')
    frankly_screenshot( filepath, region )
end

def screenshots_are_similar( screen1, screen2, threshold=0.1)
    img1 = Image.read(screen1).first
    img2 = Image.read(screen2).first
    img2.resize!(img1.columns,img1.rows)
    diff = img1.compare_channel(img2,::Magick::MeanAbsoluteErrorMetric)[1]
    diff < threshold
end

def highlight_element( selector, filepath, color )
    frankly_screenshot( filepath )
    image = Image.read( filepath ).first
    
	if selector == nil
		frame = {"origin" => {"x" => 2,"y" => 2}, "size" => {"width" => image.columns-4, "height" => image.rows-4}}
	else
		frame = frankly_map( selector, "accessibilityFrame" )[0]

    	if frame == nil
			FileUtils.rm filepath
			return
		end
	end

	highlight = Draw.new
    highlight.stroke(color).stroke_width(2)
    highlight.fill('transparent')
    highlight.roundrectangle(frame["origin"]["x"].to_i,frame["origin"]["y"].to_i,frame["origin"]["x"].to_i+frame["size"]["width"].to_i,frame["origin"]["y"].to_i+frame["size"]["height"].to_i,4,4)

    highlight.draw(image)
    image.write( filepath )
end
