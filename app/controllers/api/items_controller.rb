module Api
  class ItemsController < ApiController
    respond_to :json

    before_action :authenticated?

    def create
      list = List.find(params[:list_id])
      item = list.items.new(item_params)

      if item.save
        render json: item.to_json
      else
        render json: { errors: item.errors.full_messages },
        status: :unprocessable_entity
      end

    end

    def update
      list = List.find(params[:list_id])
      item = list.items.find(params[:id])

      if item.update(item_params)
        item.update_attribute(:completed, true)
        render json: item.to_json
      else
        render json: { errors: item.errors.full_messages },
        status: :unprocessable_entity
    end

    end


    private

    def item_params
      params.require(:item).permit(:description)
    end

  end
end
