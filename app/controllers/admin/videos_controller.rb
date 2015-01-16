class Admin::VideosController < AdminsController
  before_action :require_user

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)
    if @video.save
      flash[:success] = "You succesfully added the new video '#{@video.title}'."
      redirect_to new_admin_video_path
    else
      flash[:danger] = "You can't add this video. Please check the errors."
      render :new

    end
  end


  def video_params
    params.require(:video).permit(:title, :description, :category_id, :large_cover, :small_cover, :video_url)
  end

end