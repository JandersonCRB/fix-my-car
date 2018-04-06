class FixesController < ApplicationController
  before_action :set_fix, only: [:show, :edit, :update, :destroy, :attend]
  before_action :authenticate_user!, except: [:new]
  # GET /fixes
  # GET /fixes.json
  def index
    if(current_user.mechanical) #Caso o usuário atual não seja mêcânico
      @myFixes = Fix.where mechanical: current_user
      @waitingFixes = Fix.where status: 0
    else
      @myFixes = Fix.where(requester: current_user).where.not(status: 2)
      @waitingFixes = Fix.where(status: 2).joins("LEFT OUTER JOIN reviews ON reviews.fix_id = fixes.id").where("reviews.id IS null")
    end
  end

  # GET /fixes/1
  # GET /fixes/1.json
  def show
  end

  # GET /fixes/new
  def new
    if current_user&.mechanical
      redirect_to fixes_path
    end
    @fix = Fix.new
  end

  # GET /fixes/1/edit
  def edit
  end

  # POST /fixes
  # POST /fixes.json
  def create
    @fix = Fix.new(fix_params)
    @fix.time = Time.now
    @fix.status = 0
    @fix.requester_id = current_user.id
    respond_to do |format|
      if @fix.save
        format.html { redirect_to @fix, notice: 'Fix was successfully created.' }
        format.json { render :show, status: :created, location: @fix }
      else
        format.html { render :new }
        format.json { render json: @fix.errors, status: :unprocessable_entity }
      end
    end
  end

  def attend
    if @fix.status == 0 && current_user&.mechanical
      @fix.status = 1
      @fix.mechanical = current_user
      respond_to do |format|
        if @fix.save
          format.html { redirect_to @fix, notice: 'O usuário foi alertado e aguarda sua chegada!' }
          format.json { render :show, status: :ok, location: @fix }
        else
          format.html { render :show }
          format.json { render json: @fix.errors, status: :unprocessable_entity }
        end
      end
    elsif @fix.status == 1 && !current_user&.mechanical
      @fix.status = 2
      respond_to do |format|
        if @fix.save
          format.html { redirect_to @fix, notice: 'O usuário foi alertado e aguarda sua chegada!' } #Redirecionar para review
          format.json { render :show, status: :ok, location: @fix }
        else
          format.html { render :show }
          format.json { render json: @fix.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /fixes/1
  # PATCH/PUT /fixes/1.json
  def update
    respond_to do |format|
      if @fix.update(fix_params)
        format.html { redirect_to @fix, notice: 'Fix was successfully updated.' }
        format.json { render :show, status: :ok, location: @fix }
      else
        format.html { render :edit }
        format.json { render json: @fix.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fixes/1
  # DELETE /fixes/1.json
  def destroy
    if @fix.requester == current_user && @fix.status != 2
      @fix.destroy
      respond_to do |format|
        format.html { redirect_to fixes_url, notice: 'Fix was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to fixes_url, notice: 'Você não pode deletar esta solicitação.' }
        format.json { head :unauthorized }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fix
      @fix = Fix.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fix_params
      params.require(:fix).permit(:requester_id, :mechanical_id, :latitude, :longitude, :status)
    end
end
