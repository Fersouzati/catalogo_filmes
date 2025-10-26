class ImportsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    file = params[:csv_file]
    
    unique_filename = "#{Time.current.to_i}_#{SecureRandom.hex(4)}_#{file.original_filename}"
    path = Rails.root.join('tmp', unique_filename)
    File.open(path, 'wb') { |f| f.write(file.read) }
    import_status = current_user.import_statuses.create(status: "pending")
    ImportMoviesJob.perform_async(path.to_s, current_user.id, import_status.id)
    redirect_to import_path(import_status)
  end

  def show
    @import_status = ImportStatus.find(params[:id])
  end
end