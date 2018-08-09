class GoodsController < ApplicationController
  #authorization
  include Pundit

  before_action :find_order
  before_action :set_good, only: [:show, :edit, :update, :destroy]
  # Pundit check current_user
  before_action :authorize?, only: [:new, :edit, :update, :create, :destroy]
  # Pundit rescue not_authorized
  rescue_from Pundit::NotAuthorizedError, with: :current_user_not_authorized

  # GET /goods
  # GET /goods.json
  def index
    @goods = @order.goods.order(updated_at: :desc, created_at: :desc).page(params[:page]).per(20)
  end

  # GET /goods/1
  # GET /goods/1.json
  def show
  end

  # GET /goods/new
  def new
    @good = Good.new(order: @order)
  end

  # GET /goods/1/edit
  def edit
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(good_params)

    respond_to do |format|
      if @good.save
        format.html { redirect_to order_goods_url, notice: 'Good was successfully created.' }
        format.json { render :show, status: :created, location: @good }
      else
        format.html { render :new }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /goods/1
  # PATCH/PUT /goods/1.json
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html { redirect_to order_goods_url, notice: 'Good was successfully updated.' }
        format.json { render :show, status: :ok, location: @good }
      else
        format.html { render :edit }
        format.json { render json: @good.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    @good.destroy
    respond_to do |format|
      format.html { redirect_to order_goods_url, notice: 'Good was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_good
      @good = Good.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def good_params
      params.require(:good).permit(:order_id, :title, :price, :number)
    end

    def find_order
      @order = Order.find(params[:order_id])
    end

    def authorize?
      authorize current_user
    end

    def current_user_not_authorized
      flash[:alert] = "You are not authorized to perform this action, plz use QA account."
      redirect_to(request.referrer || root_path)
    end
end
