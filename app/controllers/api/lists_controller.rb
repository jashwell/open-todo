module Api
  class ListsController < ApiController
    respond_to :json

    before_action :authenticated?

    def index
      user = User.find(params[:user_id])
      @lists = user.lists
      render json: @lists
    end

    def show
      list = List.includes(:items).find(params[:id])
      render json: list
    end

    def create
      user = User.find(params[:user_id])
      list = List.new(list_params)
      list.user_id = user.id
      if list.save
        render json: list.to_json
      else
        render json: { errors: list.errors.full_messages }, 
        status: :unprocessable_entity
      end
    end

    def destroy
      begin
        list = List.find(params[:id])
        list.destroy

        render json: {}, status: :no_content
      rescue ActiveRecord::RecordNotFound
        render :json => {}, :status => :not_found
      end
    end

    def update
      list = List.find(params[:id])

      if list.update(list_params)
        render json: list.to_json
      else
        render json: { errors: list.errors.full_messages }, status: :unprocessable_entity
      end

    end


    def list_params
      params.require(:list).permit(:name, :permissions)

    end

  end
end
