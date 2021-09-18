class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    if invoice_item.update(invoice_item_params)
      flash[:success] = "Successfully Updated Status"
    else
      flash[:alert] = "Do Better"
    end
    redirect_to merchant_invoice_path(params[:merchant_id], invoice_item.invoice_id)
  end

  private
  def invoice_item_params
    params.require(:invoice_item).permit(:status)
  end
end