class CampersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid_response

    def index
        campers = Camper.all
        render json: campers, status: :ok
    end

    def show
        camper = find_camper
        render json: camper, serializer: CamperWithActivitiesSerializer
    end

    def create
        camper = Camper.create!(camper_params)
        render json: camper, status: :created
    end


    private

    def find_camper
        camper = Camper.find(params[:id])
        camper
    end

    def camper_params
        params.permit(:name, :age)
    end

    def render_not_found_response
        render json: {error: "Camper not found"}, status: :not_found
    end

    def render_record_invalid_response(exception)
        render json: {errors: exception.record.errors.full_messages}, status: :unprocessable_entity
    end


end
