class Adm1n::ManualInterventionsController < Adm1n::ApplicationController
  # GET /manual_interventions
  # GET /manual_interventions.xml
  def index
    @manual_interventions = ManualIntervention.todos.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @manual_interventions }
    end
  end

  # GET /manual_interventions/1
  # GET /manual_interventions/1.xml
  def show
    @manual_intervention = ManualIntervention.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @manual_intervention }
    end
  end

  # GET /manual_interventions/1/edit
  def edit
    @manual_intervention = ManualIntervention.find(params[:id])
  end

  # PUT /manual_interventions/1
  # PUT /manual_interventions/1.xml
  def update
    @manual_intervention = ManualIntervention.find(params[:id])

    respond_to do |format|
      if @manual_intervention.update_attributes(params[:manual_intervention])
        flash[:notice] = 'ManualIntervention was successfully updated.'
        format.html { redirect_to adm1n_manual_interventions_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @manual_intervention.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /manual_interventions/1
  # DELETE /manual_interventions/1.xml
  def destroy
    @manual_intervention = ManualIntervention.find(params[:id])
    @manual_intervention.destroy

    respond_to do |format|
      format.html { redirect_to(adm1n_manual_interventions_url) }
      format.xml  { head :ok }
    end
  end

  # POST /manual_interventions/1/complete
  def complete
    @manual_intervention = ManualIntervention.find(params[:id])
    @manual_intervention.complete!
    redirect_to adm1n_manual_interventions_url
  end

end
