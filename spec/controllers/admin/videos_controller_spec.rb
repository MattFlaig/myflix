require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "requires sign in" do
      let(:action) {get :new}
    end

    it "sets @video to a new video" do
      set_current_admin
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it_behaves_like "requires admin" do
      let(:action) {get :new}
    end

    it "sets the flash error message for regular user" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end

  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) {post :create}
    end

    it_behaves_like "requires admin" do
      let(:action) {post :create}
    end

    context "with valid input" do
      it "redirects to add new video page" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Lost Highway", category_id: category.id, description: "scary"}
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Lost Highway", category_id: category.id, description: "scary"}
        expect(category.videos.count).to eq(1)
      end
    

      it "sets a flash success message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {title: "Lost Highway", category_id: category.id, description: "scary"}
        expect(flash[:success]).to be_present
      end
    end
    context "with invalid input" do
      it "does not create a video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "scary"}
        expect(category.videos).to be_empty
      end

      it "renders the new template" do 
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "scary"}
        expect(response).to render_template :new
      end

      it "sets a flash error message" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "scary"}
        expect(flash[:danger]).to be_present
      end

      it "sets the @video variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: {category_id: category.id, description: "scary"}
        expect(assigns(:video)).to be_present
      end
    end
  end
end