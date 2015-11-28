class MinisoundsController < ApplicationController
  before_action :set_minisound, only: [:show, :edit, :update, :destroy]
    protect_from_forgery :except => [:create]
  # GET /minisounds
  # GET /minisounds.json
  def index
    @minisounds = Minisound.all.order("playtime")
  end

  def clean
    Minisound.delete_all
  end
  # GET /minisounds/1
  # GET /minisounds/1.json
  def show
  end

  # GET /minisounds/new
  def new
    @minisound = Minisound.new
  end

  # GET /minisounds/1/edit
  def edit
  end

  # POST /minisounds
  # POST /minisounds.json
  def create
    @minisound = Minisound.new(minisound_params)

    respond_to do |format|
      if @minisound.save
        format.html { redirect_to @minisound, notice: 'Minisound was successfully created.' }
        format.json { render :show, status: :created, location: @minisound }
      else
        format.html { render :new }
        format.json { render json: @minisound.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /minisounds/1
  # PATCH/PUT /minisounds/1.json
  def update
    respond_to do |format|
      if @minisound.update(minisound_params)
        format.html { redirect_to @minisound, notice: 'Minisound was successfully updated.' }
        format.json { render :show, status: :ok, location: @minisound }
      else
        format.html { render :edit }
        format.json { render json: @minisound.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /minisounds/1
  # DELETE /minisounds/1.json
  def destroy
    @minisound.destroy
    respond_to do |format|
      format.html { redirect_to minisounds_url, notice: 'Minisound was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_minisound
      @minisound = Minisound.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def minisound_params
      params.require(:minisound).permit(:video_id, :name, :playtime)
    end
end
