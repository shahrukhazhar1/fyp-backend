class Api::V1::MailingListController < ApplicationController
  before_action :load_mailing_list, only: [:create_entry]

  def create_entry
    if @mailing_list.present?
      e = MailingListEntry.new(entry_params)
      e.mailing_list = @mailing_list
      if e.valid?
        e.save!

        render json: e.slice(:name, :email), status: 201
      else
        render json: e.errors, status: 422
      end
    else
      head 404, "content_type" => "text/plain"
    end
  end

  private

  def load_mailing_list
    @mailing_list = MailingList.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:email, :name)
  end
end
