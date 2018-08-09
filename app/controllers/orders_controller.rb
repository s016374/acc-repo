class OrdersController < ApplicationController
  # authorization
  include Pundit

  before_action :set_order, only: [:show, :edit, :update, :destroy]
  # Pundit check current_user
  before_action :authorize?, only: [:new, :edit, :update, :create, :destroy, :purchase]
  # Pundit rescue not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :current_user_not_authorized

  # GET /orders
  # GET /orders.json
  def index
    # sort by <th>
    orders = params[:sort] && params[:direction] ? Order.order(params[:sort] + ' ' + params[:direction]) : Order.all

    # filter index
    orders = Order.my_search(['customer', 'phone', 'address', 'comment'], params[:q].strip) unless params[:q].nil?

    # pageable
    @orders = orders.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(20)
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # purchase: is_purchase == 1
  # order: is_purchase != 1
  def purchase
    @order = Order.new(is_purchase: 1)
    render :new
  end

  # when input item keyword, ajax return item name.
  def get_items
    keyword = params[:item_keyword].blank? ? "KEYWORD_IS_BLANK_SO_NO_ITEM" : params[:item_keyword].strip
    @selected_items = Item.my_find('title', keyword)
    render layout: false
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    if params[:add_good]
      # add empty good associated with @order
      @order.goods.build
      render 'new' and return
    elsif params[:remove_good]
      # nested model that have _destroy attribute = 1 automatically deleted by rails
      render 'new' and return
    end
    respond_to do |format|
      if @order.save
        format.html { redirect_to orders_url, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to orders_url, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:customer, :is_purchase, :phone, :address, :comment, goods_attributes: [:id, :title, :price, :number, :_destroy])
    end

    def authorize?
      authorize current_user
    end

    def current_user_not_authorized
      flash[:alert] = "You are not authorized to perform this action, please use ADMIN account."
      redirect_to(request.referrer || root_path)
    end
end
