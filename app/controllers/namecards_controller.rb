class NamecardsController < ApplicationController
  before_action :set_namecard, only: [:show, :edit, :update, :destroy]

  # GET /namecards
  # GET /namecards.json
  def index
    @namecards = Namecard.page(params[:page]).per(3)
  end

  # GET /namecards/1
  # GET /namecards/1.json
  def show
  end

  # GET /namecards/new
  def new
    @namecard = Namecard.new
  end

  # GET /namecards/1/edit
  def edit
  end

  # POST /namecards
  # POST /namecards.json
  def create
    @namecard = Namecard.new(namecard_params)

    respond_to do |format|
      if @namecard.save
        format.html { redirect_to @namecard, notice: 'Namecard was successfully created.' }
        format.json { render :show, status: :created, location: @namecard }
      else
        format.html { render :new }
        format.json { render json: @namecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /namecards/1
  # PATCH/PUT /namecards/1.json
  def update
    respond_to do |format|
      if @namecard.update(namecard_params)
        format.html { redirect_to @namecard, notice: 'Namecard was successfully updated.' }
        format.json { render :show, status: :ok, location: @namecard }
      else
        format.html { render :edit }
        format.json { render json: @namecard.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /namecards/1
  # DELETE /namecards/1.json
  def destroy
    @namecard.destroy
    respond_to do |format|
      format.html { redirect_to namecards_url, notice: 'Namecard was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_namecard
      @namecard = Namecard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def namecard_params
      params.require(:namecard).permit(:name, :tel, :address, :company)
    end
end
