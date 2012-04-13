require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ForfaitsController do

  # This should return the minimal set of attributes required to create a valid
  # Forfait. As you add validations to Forfait, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ForfaitsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all forfaits as @forfaits" do
      forfait = Forfait.create! valid_attributes
      get :index, {}, valid_session
      assigns(:forfaits).should eq([forfait])
    end
  end

  describe "GET show" do
    it "assigns the requested forfait as @forfait" do
      forfait = Forfait.create! valid_attributes
      get :show, {:id => forfait.to_param}, valid_session
      assigns(:forfait).should eq(forfait)
    end
  end

  describe "GET new" do
    it "assigns a new forfait as @forfait" do
      get :new, {}, valid_session
      assigns(:forfait).should be_a_new(Forfait)
    end
  end

  describe "GET edit" do
    it "assigns the requested forfait as @forfait" do
      forfait = Forfait.create! valid_attributes
      get :edit, {:id => forfait.to_param}, valid_session
      assigns(:forfait).should eq(forfait)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Forfait" do
        expect {
          post :create, {:forfait => valid_attributes}, valid_session
        }.to change(Forfait, :count).by(1)
      end

      it "assigns a newly created forfait as @forfait" do
        post :create, {:forfait => valid_attributes}, valid_session
        assigns(:forfait).should be_a(Forfait)
        assigns(:forfait).should be_persisted
      end

      it "redirects to the created forfait" do
        post :create, {:forfait => valid_attributes}, valid_session
        response.should redirect_to(Forfait.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved forfait as @forfait" do
        # Trigger the behavior that occurs when invalid params are submitted
        Forfait.any_instance.stub(:save).and_return(false)
        post :create, {:forfait => {}}, valid_session
        assigns(:forfait).should be_a_new(Forfait)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Forfait.any_instance.stub(:save).and_return(false)
        post :create, {:forfait => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested forfait" do
        forfait = Forfait.create! valid_attributes
        # Assuming there are no other forfaits in the database, this
        # specifies that the Forfait created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Forfait.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => forfait.to_param, :forfait => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested forfait as @forfait" do
        forfait = Forfait.create! valid_attributes
        put :update, {:id => forfait.to_param, :forfait => valid_attributes}, valid_session
        assigns(:forfait).should eq(forfait)
      end

      it "redirects to the forfait" do
        forfait = Forfait.create! valid_attributes
        put :update, {:id => forfait.to_param, :forfait => valid_attributes}, valid_session
        response.should redirect_to(forfait)
      end
    end

    describe "with invalid params" do
      it "assigns the forfait as @forfait" do
        forfait = Forfait.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Forfait.any_instance.stub(:save).and_return(false)
        put :update, {:id => forfait.to_param, :forfait => {}}, valid_session
        assigns(:forfait).should eq(forfait)
      end

      it "re-renders the 'edit' template" do
        forfait = Forfait.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Forfait.any_instance.stub(:save).and_return(false)
        put :update, {:id => forfait.to_param, :forfait => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested forfait" do
      forfait = Forfait.create! valid_attributes
      expect {
        delete :destroy, {:id => forfait.to_param}, valid_session
      }.to change(Forfait, :count).by(-1)
    end

    it "redirects to the forfaits list" do
      forfait = Forfait.create! valid_attributes
      delete :destroy, {:id => forfait.to_param}, valid_session
      response.should redirect_to(forfaits_url)
    end
  end

end
