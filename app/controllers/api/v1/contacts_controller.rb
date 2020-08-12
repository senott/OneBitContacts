class Api::V1::ContactsController < Api::V1::ApiController
  before_action :set_contact, only: %i[show update destroy]
  before_action :require_authorization!, only: %i[show update destroy]

  #
  # GET /api/v1/contacts
  #
  def index
    page = params[:page]? params[:page] : 1

    @contacts = current_user.contacts.page page

    render json: @contacts
  end

  #
  # GET /api/v1/contacts/:id
  #
  def show
    render json: @contact
  end

  #
  # POST /api/v1/contacts
  #
  def create
    @contact = Contact.new(contact_params.merge(user: current_user))

    if @contact.save

      render json: @contact, status: :created

    else

      render json: @contact.errors, status: :unprocessable_entity

    end
  end

  #
  # PATCH/PUT /api/v1/contacts/:id
  #
  def update
    if @contact.update(contact_params)

      render json: @contact

    else

      render json: @contact.errors, status: :unprocessable_entity

    end
  end

  #
  # DELETE /api/v1/contacts/:id
  #
  def destroy
    @contact.destroy
    head 204
  end

  private

  # Use callbacks to share common setup or constraints between actions
  def set_contact
    @contact = Contact.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { message: e.message}, status: :not_found
  end

  # Only allow a trusted parameter "white list" through
  def contact_params
    params.require(:contact).permit(:name, :email, :phone, :description)
  end

  def require_authorization!
    render json: {}, status: :forbidden unless current_user == @contact.user
  end
end
