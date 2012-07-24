class Api::V1::UndosController < Api::BaseController
  respond_to :json

  def destroy
    path = Undoable.undo(params[:id])
    respond_with do |format|
      format.json { render :text => path, :status => 200 }
    end
  end
end
