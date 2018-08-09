class ItemsController < ApplicationController
  #authorization
  include Pundit

  before_action :find_vendor
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  # Pundit check current_user
  before_action :authorize?, only: [:new, :edit, :update, :create, :destroy]
  # Pundit rescue not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :current_user_not_authorized

  # GET /items
  # GET /items.json
  def index
    # sort by <th>
    items = params[:sort] && params[:direction] ? @vendor.items.order(params[:sort] + ' ' + params[:direction]) : @vendor.items

    # filter index
    items = @vendor.items.my_search(['title', 'description'], params[:q].strip) unless params[:q].nil?

    @items = items.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(20)
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new(vendor: @vendor)
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to vendor_items_url, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to vendor_items_url, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to vendor_items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:vendor_id, :title, :stock, :total, :expected_price, :actual_price, :cost, :style, :description)
    end

    def find_vendor
      @vendor = Vendor.find(params[:vendor_id])
    end

    def authorize?
      authorize current_user
    end

    def current_user_not_authorized
      flash[:alert] = "You are not authorized to perform this action, plz use QA account."
      redirect_to(request.referrer || root_path)
    end
end
