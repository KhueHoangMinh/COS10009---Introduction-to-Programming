# require 'rubygems'
# require 'gosu'
# require './bezier_curve'

# # The screen has layers: Background, middle, top

# module ZOrder
#   BACKGROUND, MIDDLE, TOP = *0..2
# end

# class DemoWindow < Gosu::Window
#     def initialize
#         super(400, 400, false)
#         self.caption = "Curves Example"
#     end

#     def needs_cursor?
#         true
#     end

#     def draw
#         draw_curve(150, 25, 150, 75, 100, 25, 200, 75, 2, Gosu::Color::YELLOW, 5)
#         draw_curve(100, 25, 100, 75, 50, 25, 150, 75, 2, Gosu::Color::YELLOW, 5)
#         draw_curve(200, 25, 200, 75, 150, 25, 250, 75, 2, Gosu::Color::YELLOW, 5)
#         draw_curve(100, 100, 100, 150, 75, 100, 75, 150, 2, Gosu::Color::BLUE, 10)
#         draw_curve(100, 100, 100, 150, 125, 100, 125, 150, 2, Gosu::Color::BLUE, 10)
#         draw_curve(200, 100, 200, 150, 175, 100, 175, 150, 2, Gosu::Color::BLUE, 10)
#         draw_curve(200, 100, 200, 150, 225, 100, 225, 150, 2, Gosu::Color::BLUE, 10)
#         draw_curve(100, 200, 200, 200, 125, 250, 175, 250, 2, Gosu::Color::RED, 10) 
#     end
# end

# DemoWindow.new.show
require 'gosu'
require './circle.rb'

class Draw < Gosu::Window
    def initialize
        super(1000,1000,false)
        self.caption = 'Bright Sun'
        @circle1 = Gosu::Image.new(Circle.new(80))
        @circle2 = Gosu::Image.new(Circle.new(40))
        @circle3 = Gosu::Image.new(Circle.new(60))

    end

    def update
    end

    def draw
        @circle1.draw(420,420,11,1.0,1.0, Gosu::Color::YELLOW)
        
        






































































































        
        @circle2.draw(460,460,13,1.0,1.0, Gosu::Color::RED)
        draw_quad(500-200,500-200,Gosu::Color::WHITE,500,500-100,Gosu::Color::WHITE,500-100,500,Gosu::Color::WHITE,500,500,Gosu::Color::WHITE,10)
        draw_quad(500,500-100,Gosu::Color::RED,500+200,500-200,Gosu::Color::RED,500,500,Gosu::Color::RED,500+100,500,Gosu::Color::RED,10)
        draw_quad(500-100,500,Gosu::Color::RED,500,500,Gosu::Color::RED,500-200,500+200,Gosu::Color::RED,500,500+100,Gosu::Color::RED,10)
        draw_quad(500,500,Gosu::Color::WHITE,500+100,500,Gosu::Color::WHITE,500,500+100,Gosu::Color::WHITE,500+200,500+200,Gosu::Color::WHITE,10)

        draw_quad(0,0,0xff_330000,500,0,0xff_330000,0,500,0xff_330000,500,500,Gosu::Color::YELLOW,8)
        draw_quad(500,500,Gosu::Color::YELLOW,1000,500,0xff_333333,500,0,0xff_333333,1000,0,0xff_333333,8)
        draw_quad(0,1000,0xff_333333,500,1000,0xff_333333,0,500,0xff_333333,500,500,Gosu::Color::YELLOW,8)
        draw_quad(500,500,Gosu::Color::YELLOW,1000,500,0xff_330000,500,1000,0xff_330000,1000,1000,0xff_330000,8)

        draw_triangle(500,500-50,Gosu::Color::YELLOW,500,500+50,Gosu::Color::YELLOW,500+450,500,Gosu::Color::YELLOW,9,mode=:default)
        draw_triangle(500-50,500,Gosu::Color::YELLOW,500,500-450,Gosu::Color::YELLOW,500+50,500,Gosu::Color::YELLOW,9,mode=:default)
        draw_triangle(500,500-50,Gosu::Color::YELLOW,500,500+50,Gosu::Color::YELLOW,500-450,500,Gosu::Color::YELLOW,9,mode=:default)
        draw_triangle(500-50,500,Gosu::Color::YELLOW,500,500+450,Gosu::Color::YELLOW,500+50,500,Gosu::Color::YELLOW,9,mode=:default)
        Array.new(10).map() {
            self.twink(rand(0..1000),rand(0..1000),rand(2..10),rand(30..40),rand(8..12),Gosu::Color::GREEN)
        }
    end

    def twink(x,y,sizebase,sizeheight,zorder,color)
        draw_triangle(x,y-sizebase,color,x,y+sizebase,color,x+sizeheight,y,color,zorder,mode=:default)
        draw_triangle(x-sizebase,y,color,x,y-sizeheight,color,x+sizebase,y,color,zorder,mode=:default)
        draw_triangle(x,y-sizebase,color,x,y+sizebase,color,x-sizeheight,y,color,zorder,mode=:default)
        draw_triangle(x-sizebase,y,color,x,y+sizeheight,color,x+sizebase,y,color,zorder,mode=:default)
    end
end

Draw.new.show
