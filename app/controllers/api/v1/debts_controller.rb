require "debt_adder"

class Api::V1::DebtsController < ApplicationController
  respond_to :json
  
  def create
    giver = Person.find(params[:giver_id])
    takers = Person.where(:id => params[:taker_ids].split(","))
    group = Group.find(params[:group_id])
    amount = params[:amount].to_i
    respond_with(DebtAdder.new(giver, takers, group, amount).add_debt, :location => "")
  end
  
end
