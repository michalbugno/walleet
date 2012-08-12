require "debt_adder"

class Api::V1::DebtsController < Api::BaseController
  respond_to :json

  def create
    giver = GroupMembership.find(params[:giver_id])
    takers = GroupMembership.where(:id => params[:taker_ids].split(","))
    amount = params[:amount]
    amount = amount.gsub(",", ".").to_f
    adder = DebtAdder.new(giver, takers, amount)
    adder.add_debt
    respond_with("", :location => "")
  end

end
