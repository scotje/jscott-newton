class Admin::SettingsController < Admin::BaseController
  before_filter { @page_title = "Settings" }
  
  def index
    @settings = Setting.order('system DESC, key ASC')
  end
  
  def update
    params[:settings].each do |id, data|
      begin
        setting = Setting.find(id.to_i)
        setting.value = data['value'].present? ? data['value'].strip : nil
        setting.save!
      rescue
        flash[:error] = "One or more settings could not be updated, please verify your changes. System settings cannot be blank."
      end
    end
    
    flash[:notice] = "Settings updated successfully." if flash[:error].blank?
    
    redirect_to admin_settings_url
  end
  
  def new
    if flash[:setting].present?
      @setting = flash[:setting]
    else
      @setting = Setting.new
    end
  end
  
  def create
    @setting = Setting.new(params[:setting])
    @setting.setting_type = 'string'
    @setting.value.strip!
    @setting.system = false
    
    if @setting.save
      redirect_to admin_settings_url
    else
      flash[:setting] = @setting
      
      redirect_to new_admin_setting_url
    end
  end
  
  def destroy
    @setting = Setting.find(params[:id])
    
    if !@setting.system
      @setting.destroy
    else
      flash[:error] = "You can't delete a system setting."
    end

    redirect_to admin_settings_url
  end
end
