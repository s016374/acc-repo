class VendorsController < ApplicationController
  #authorization
  include Pundit

  before_action :set_vendor, only: [:show, :edit, :update, :destroy]
  # Pundit check current_user
  before_action :authorize?, only: [:new, :edit, :update, :create, :destroy]
  # Pundit rescue not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :current_user_not_authorized

  # GET /vendors
  # GET /vendors.json
  def index
    # sort by <th>
    vendors = params[:sort] && params[:direction] ? Vendor.order(params[:sort] + ' ' + params[:direction]) : Vendor.all

    # filter index
    vendors = Vendor.my_search(['title', 'phone', 'address', 'description'], params[:q].strip) unless params[:q].nil?

    # pageable
    @vendors = vendors.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(20)
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendors_url, notice: 'Vendor was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1
  # PATCH/PUT /vendors/1.json
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendors_url, notice: 'Vendor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: 'Vendor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vendor_params
      params.require(:vendor).permit(:title, :description, :phone, :address)
    end

    def authorize?
      authorize current_user
    end

    def current_user_not_authorized
      flash[:alert] = "You are not authorized to perform this action, please use ADMIN account."
      redirect_to(request.referrer || root_path)
    end
end
