class Api::V2::ContactsController < Api::V1::ApiController
  before_action :set_contact, only: %i[show update destroy]
  before_action :require_authorization!, only: %i[show update destroy]

  #
  # GET /api/v2/contacts
  #
  def index
    page = params[:page]? params[:page] : 1

    @contacts = current_user.contacts.includes(:addresses).page page

    render 'contacts/v2/index.json'

  end

  #
  # GET /api/v2/contacts/:id
  #
  def show
    render 'contacts/v2/show.json'
  end

  #
  # POST /api/v2/contacts
  #
  def create
    @contact = Contact.new(
      name: contact_params[:name],
      email: contact_params[:email],
      phone: contact_params[:phone],
      description: contact_params[:description],
      user: current_user
    )

    if @contact.save

      unless contact_params[:addresses].blank?
        @contact.addresses.create(contact_params[:addresses])
      end

      render 'contacts/v2/show.json', status: :created

    else

      render json: @contact.errors, status: :unprocessable_entity

    end
  end

  #
  # PATCH/PUT /api/v1/contacts/:id
  #
  def update
    if @contact.update(
      name: contact_params[:name],
      email: contact_params[:email],
      phone: contact_params[:phone],
      description: contact_params[:description]
    )

    if @contact.addresses && !contact_params[:addresses].blank?

      @contact.addresses.destroy_all

      @contact.addresses.create(contact_params[:addresses])

    end

      render 'contacts/v2/show.json', status: :ok

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
    params.require(:contact).permit(:name, :email, :phone, :description, 
      addresses: %i[line1 line2 city state zip]
    )
  end

  def require_authorization!
    render json: {}, status: :forbidden unless current_user == @contact.user
  end

end
