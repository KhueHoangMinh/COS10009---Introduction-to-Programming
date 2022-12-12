require 'gosu'
require './circle.rb'

class Draw < Gosu::Window
    def initialize
        super(1000,1000,false)
        self.caption = 'Shuriken'
    end

    def update
    end

    def draw
        Gosu::Image.new(Circle.new(80)).draw(420,420,11,1.0,1.0, Gosu::Color::YELLOW)

        draw_quad(500-100,500-100,Gosu::Color::RED,500+100,500-100,Gosu::Color::GREEN,500-100,500+100,Gosu::Color::BLUE,500+100,500+100,Gosu::Color::YELLOW,10)

        draw_triangle(500,500-30,Gosu::Color::RED,500,500+30,Gosu::Color::GREEN,500+470,500,Gosu::Color::YELLOW,9)
        draw_triangle(500-30,500,Gosu::Color::GREEN,500,500-470,Gosu::Color::BLUE,500+30,500,Gosu::Color::RED,9)
        draw_triangle(500,500-30,Gosu::Color::BLUE,500,500+30,Gosu::Color::YELLOW,500-470,500,Gosu::Color::GREEN,9)
        draw_triangle(500-30,500,Gosu::Color::YELLOW,500,500+470,Gosu::Color::RED,500+30,500,Gosu::Color::BLUE,9)
        
    end
end

Draw.new.show
