class ConnectionPropositionsController < ApplicationController
  def show
    @resource = ConnectionProposition.find params[:id]

    @reject_event = @resource.aasm.events.detect {|e| e.to_s =~ /reject/}
    @accept_event = @resource.aasm.events.detect {|e| e.to_s =~ /accept/}

    render layout: false
  end

  def update
    @cp = ConnectionProposition.find params[:id]

    # update the reject_description
    @cp.attributes =
    params.require(:connection_proposition).permit(:reject_description)

    if ConnectionProposition.aasm_events.keys.include? params[:commit].to_sym
      @cp.send params[:commit]
    end
    # TODO
    notice = ""

    if @cp.save
      redirect_options = {notice: notice}
    else
      redirect_options = {alert: "Unable to save the connection proposition"}
    end

    redirect_to account_path, redirect_options
  end
end
