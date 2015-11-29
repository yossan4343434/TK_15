class SoundsController < ApplicationController
  before_action :set_sound, only: [:show, :edit, :update, :destroy]

  # GET /sounds
  # GET /sounds.json
  def index
    @sounds = Sound.all.order("playtime")
  end

  # GET /sounds/1
  # GET /sounds/1.json
  def show
  end

  def reset
    Sound.all.each do |sound|
      sound.destroy
    end
    redirect_to :root
  end

  # GET /sounds/new
  def new
    @sound = Sound.new
  end

  # GET /sounds/1/edit
  def edit
  end

  def download
    sound = Sound.find_by(id:params[:id])
    puts sound.name
    filename = sound.name
    filepath = Rails.root.join('public/sound',filename)
    stat = File::stat(filepath)
    send_file(filepath, :filename => filename, :length => stat.size)
  end

  # POST /sounds
  # POST /sounds.json
  def create
    sound = Sound.find_or_create_by(name: params[:name])
    sound.video_id = params[:video_id].to_i
    sound.playtime = params[:playtime].to_f
    sound.sound = params[:sound]
    sound.save!
    render json: {
      name: sound.name,
      sound: sound.sound
    }
  end

  # PATCH/PUT /sounds/1
  # PATCH/PUT /sounds/1.json
  def update
    respond_to do |format|
      if @sound.update(sound_params)
        format.html { redirect_to @sound, notice: 'Sound was successfully updated.' }
        format.json { render :show, status: :ok, location: @sound }
      else
        format.html { render :edit }
        format.json { render json: @sound.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sounds/1
  # DELETE /sounds/1.json
  def destroy
    @sound.destroy
    # File.delete("./sound/" + @sound.name)
    respond_to do |format|
      format.html { redirect_to sounds_url, notice: 'Sound was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sound
      @sound = Sound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sound_params
      params.require(:sound).permit(:name, :video_id, :playtime, :sound)
    end
end
