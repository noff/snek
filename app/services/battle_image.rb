class BattleImage

  include Magick
  include BattleHelper

  attr_accessor :battle, :padding, :width, :height, :arena_width, :arena_height, :cell_size, :arena

  def initialize(battle)
    @battle = battle
  end

  def for_facebook
    @width = 1200
    @height = 630
    @padding = 30

    # Calculate elements size
    @arena = @battle.arena
    @arena_width = @arena.get_matrix.width
    @arena_height = @arena.get_matrix.height
    @cell_size = ((@height - 2 * @padding) / @arena_height).floor

    # Prepare result image
    final_image = Image.new(@width, @height)

    # Draw walls
    @arena.get_matrix.area.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        Rails.logger.warn cell
        case cell
        when 'wall'
          p_x, p_y = get_block_coords(x, y)
          final_image.composite!(get_wall, p_x, p_y, Magick::OverCompositeOp)
        when 'empty'
          gc = Draw.new
          if (x + y).odd?
            gc.fill '#555555'
          else
            gc.fill '#646464'
          end
          gc.fill_opacity 100
          p_x, p_y = get_block_coords(x, y)
          gc.rectangle p_x,p_y, p_x + @cell_size, p_y + @cell_size
          gc.draw(final_image)
        end
      end
    end

    # Draw sneks
    if @battle.battle_rounds.exists?
      battle_round = @battle.battle_rounds.take(30).sample
      battle_round.sneks.each do |snek_data|
        snek = Snek.find(snek_data['snek_id'])
        snek_parts = {
            tail: Image.read(File.join(Rails.root, 'app', 'assets', 'images', 'snek', "tail_#{snek.color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            tail_skin: Image.read( File.join(Rails.root, 'app', 'assets', 'images', 'skin', "pattern_#{snek.pattern}_tail_#{snek.pattern_color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            body: Image.read(File.join(Rails.root, 'app', 'assets', 'images', 'snek', "body_#{snek.color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            body_skin: Image.read( File.join(Rails.root, 'app', 'assets', 'images', 'skin', "pattern_#{snek.pattern}_body_#{snek.pattern_color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            curve: Image.read(File.join(Rails.root, 'app', 'assets', 'images', 'snek', "curve_#{snek.color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            curve_skin: Image.read( File.join(Rails.root, 'app', 'assets', 'images', 'skin', "pattern_#{snek.pattern}_curve_#{snek.pattern_color}.png")).first.resize_to_fit!(@cell_size, @cell_size),
            head: Image.read(File.join(Rails.root, 'app', 'assets', 'images', 'snek', "head_#{snek.color}.png")).first.resize_to_fit!(@cell_size, @cell_size)
        }
        length = snek_data['position'].length
        snek_data['position'].each_with_index do |position, index|
          p_x, p_y = get_block_coords(position['x'], position['y'])
          if index == 0
            rotate = 0
            if snek_data['position'][1]['y'] < position['y']
              rotate = -90
            elsif snek_data['position'][1]['y'] > position['y']
              rotate = 90
            elsif snek_data['position'][1]['x'] < position['x']
              rotate = 180
            elsif snek_data['position'][1]['x'] > position['x']
              rotate = 0
            end
            final_image.composite!(snek_parts[:head].rotate(rotate), p_x, p_y, Magick::OverCompositeOp)
          elsif index == (length - 1)
            rotate = 0
            if snek_data['position'][index - 1]['y'] > position['y']
              rotate = -90
            elsif snek_data['position'][index - 1]['y'] < position['y']
              rotate = 90
            elsif snek_data['position'][index - 1]['x'] > position['x']
              rotate = 180
            elsif snek_data['position'][index - 1]['x'] < position['x']
              rotate = 0
            end
            final_image.composite!(snek_parts[:tail].rotate(rotate), p_x, p_y, Magick::OverCompositeOp)
            final_image.composite!(snek_parts[:tail_skin].rotate(rotate), p_x, p_y, Magick::OverCompositeOp)
          else
            rotate = 0
            body = snek_parts[:body]
            skin = snek_parts[:body_skin]
            prev_position = snek_data['position'][index - 1]
            next_position = snek_data['position'][index + 1]
            if prev_position && next_position && position
              if prev_position['y'] == next_position['y']
                # Everything is OK
              elsif prev_position['x'] == next_position['x']
                rotate = 90
              else
                # Curve
                body = snek_parts[:curve]
                skin = snek_parts[:curve_skin]
                if prev_position['y'] === position['y'] && prev_position['y'] < next_position['y'] && prev_position['x'] < position['x'] && position['x'] === next_position['x']
                  rotate = 0
                end
                if next_position['y'] === position['y'] && next_position['y'] < prev_position['y'] && next_position['x'] < position['x'] && position['x'] === prev_position['x']
                  rotate = 0
                end

                if prev_position['y'] === position['y'] && prev_position['y'] < next_position['y'] && prev_position['x'] > position['x'] && position['x'] === next_position['x']
                  rotate = 270
                end
                if next_position['y'] === position['y'] && next_position['y'] < prev_position['y'] && next_position['x'] > position['x'] && position['x'] === prev_position['x']
                  rotate = 270
                end

                if prev_position['y'] === position['y'] && prev_position['y'] > next_position['y'] && prev_position['x'] > position['x'] && position['x'] === next_position['x']
                    rotate = 180
                end
                if next_position['y'] === position['y'] && next_position['y'] > prev_position['y'] && next_position['x'] > position['x'] && position['x'] === prev_position['x']
                    rotate = 180
                end

                if prev_position['y'] === position['y'] && prev_position['y'] > next_position['y'] && prev_position['x'] < position['x'] && position['x'] === next_position['x']
                    rotate = 90
                end
                if next_position['y'] === position['y'] && next_position['y'] > prev_position['y'] && next_position['x'] < position['x'] && position['x'] === prev_position['x']
                  rotate = 90
                end
              end
            end

            # Heading
            heading = Magick::Draw.new
            heading.font_family = 'helvetica'
            heading.pointsize = 52
            heading.gravity = Magick::NorthWestGravity
            heading.annotate(final_image, 0,0, 630, 50, battle_name(@battle)) {
              self.fill = '#333333'
              self.font_weight = BoldWeight
            }

            # Snek names
            @battle.snek_battles.each_with_index do |snek_battle, index|
              heading = Magick::Draw.new
              heading.font_family = 'helvetica'
              heading.pointsize = 24
              heading.gravity = Magick::NorthWestGravity
              heading.font_weight = NormalWeight
              heading.annotate(final_image, 0,0, 630, 140 + index * 40, "#{ index + 1 }. #{snek_battle.snek.short_name}") {
                self.fill = '#333333'
              }
            end


            final_image.composite!(body.rotate(rotate), p_x, p_y, Magick::OverCompositeOp)
            final_image.composite!(skin.rotate(rotate), p_x, p_y, Magick::OverCompositeOp)
          end

        end
      end
    end


    # Result
    final_image.to_blob { self.format = 'png' }
  end




  def get_wall
    unless @wall
      @wall = Image.read(File.join(Rails.root, 'app', 'assets', 'images', 'arena', 'wall.png')).first
      @wall.resize_to_fit!(@cell_size, @cell_size)
    end
    @wall
  end


  # Returns absolute pixel coordinates of arena's cell
  def get_block_coords(x, y)
    return (@padding + x * @cell_size), (@padding + y * @cell_size)
  end


end