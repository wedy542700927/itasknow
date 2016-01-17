#encoding: utf-8
class UsersController < ApplicationController
  def register
    @user = User.new
    render 'register', layout: 'register'
  end

  def register_confirm
    @user = User.new params.require(:user).permit(:username,:nickname,:email,:password,:password_confirmation),credits: 10
    if @user.save
      #to_login @user
      session[:wait_active_email] = @user.email
      redirect_to send_active_mail_users_path
    else
      render 'register', layout: 'register'
    end
  end

  def login
    return redirect_to(login_path(from: referer)) unless params[:from].present?
    @user = User.new
    render 'login', layout: 'register'
  end

  def login_confirm
    @user = User.find_by username: params[:user][:username]
    unless @user.activation?
      session[:wait_active_email] = @user.email
      flash.now[:error] = "用户还没有激活，<a href='#{send_active_mail_users_path}'>点此</a>发送激活邮件。"
      return render 'login', layout: 'register'
    end
    if @user && @user.check_password(params[:user][:password]) && !@user.admin
      to_login @user
      if !@user.last_login_time.present? 
        @user.update_attributes(:last_login_time=>DateTime.now,:credits=>@user.credits+10)
      elsif  @user.last_login_time.year==DateTime.now.year && @user.last_login_time.month==DateTime.now.month && @user.last_login_time.day==DateTime.now.day
        @user.update_attributes(:last_login_time=>DateTime.now)
      else 
        @user.update_attributes(:last_login_time=>DateTime.now,:credits=>@user.credits+10)
      end
      redirect_to root_path
      # (params[:from].present? ? params[:from] : root_path)
    else
      flash[:error] = '用户名或密码错误'
      render 'login', layout: 'register'
    end
  rescue
    flash[:error] = '用户名或密码错误'
    render 'login', layout: 'register'
  end

  def logout
    session[:user_id] = nil
    # redirect_to referer
    redirect_to root_path
  end

  def send_active_mail
    @result = {status: false, message: ''}
    if session[:wait_active_email]
      wait_user = User.find_by email: session[:wait_active_email]
      if wait_user.activation?
        flash[:success] = '您的账号已经激活，请登录'
        return redirect_to login_path
      end
      if wait_user.present?
        token = UserActive.generate_token
        active = UserActive.new user_id: wait_user.id, type_name: 'Active', token: token
        url = File.join(Settings.itask.domain, "users/activation?token=#{token}")
        if active.save && UserMailer.auth_mail(session[:wait_active_email], url).deliver
          @result[:status] = true
          @result[:message] = session[:wait_active_email]
        end
      end
    end
  end

  def activation
    active = UserActive.where(type_name: 'Active', token: params[:token], used: 'f').order('created_at desc').first
    if active && !active.used?
      user = User.find active.user_id
      user.activation = 1
      active.used = 1
      if user.save && active.save
        flash[:success] = '激活成功，请登录'
        redirect_to login_path
      else
        flash[:error] = '激活失败，请重试，如果还不能激活，请联系管理员'
        redirect_to login_path
      end
    else
      flash[:error] = 'token不存在'
      redirect_to root_path
    end
  end

  def forget_password
    render 'forget_password', layout: 'register'
  end

  def forget_password_confirm
    @result = {status: false, message: ''}
    if params[:user][:email].present?
      user = User.find_by email: params[:user][:email]
      return redirect_to(root_path) unless user
      token = UserActive.generate_token
      active = UserActive.new user_id: user.id, token: token, type_name: 'ForgetPassword'
      url = File.join(Settings.itask.domain, "users/change_pw?token=#{token}")
      if active.save && UserMailer.forget_password(user.email, url).deliver
        @result[:status] = true
        @result[:message] = user.email
      else
        flash.now[:error] = '邮件发送失败，请重试'
        render 'forget_password', layout: 'register'
      end
    end
  end

  def change_pw
    @token = params[:token]
    active = UserActive.where(type_name: 'ForgetPassword', token: @token, used: 'f').order('created_at desc').first
    return redirect_to(root_path) unless active
    if Time.now.to_i - active.created_at.to_i > 600
      return redirect_to root_path
    end
    render 'change_pw', layout: 'register'
  end

  def change_pw_confirm
    @token = params[:user][:token]
    active = UserActive.where(type_name: 'ForgetPassword', token: @token, used: 'f').order('created_at desc').first
    return redirect_to(root_path) unless active
    @user = User.find active.user_id
    return redirect_to(root_path) unless @user
    @user.password = params[:user][:password] || ''
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:success] = '重置密码成功，请登录'
      redirect_to login_path
    else
      flash.now[:error] = @user.errors.full_messages.first
      render 'change_pw', layout: 'register'
    end
  end
def set

  end

  def set_userinfo
    user = User.find @current_user.id
    user.nickname = params[:user][:nickname] if params[:user][:nickname].present?
    user.name = params[:user][:name] if params[:user][:name].present?
    user.student_id = params[:user][:student_id] if params[:user][:student_id].present?
    user.email = params[:user][:email] if params[:user][:email].present?
    user.description = params[:user][:description] if params[:user][:description].present?
    begin
      if params[:user][:avatar].present?
        upload_info = upload_picture params[:user][:avatar]
        user.avatar = "/images/#{upload_info[:real_file_name]}"
      end
    rescue UploadException => e
      flash.now[:error] = e.message
      render 'set'
    else
      if user.save
        flash[:success] = '修改成功'
        redirect_to set_users_path
      else
        flash.now[:error] = user.errors.full_messages.first
        render 'set'
      end
    end
  end


  def change_password

  end
 def update_password
    @user = User.find @current_user.id
    if @user.check_password(params[:user][:old_password])
      @user.password = params[:user][:password] || ''
      @user.password_confirmation = params[:user][:password_confirmation] || ''
      if @user.save
        flash[:success] = '修改密码成功，请重新登录'
        redirect_to login_path
      else
        render 'change_password'
      end
    else
      flash.now[:error] = '原密码错误'
      render 'change_password'
    end
  end
  def upload_img
    @result = {status: false, message: '', text_id: params[:upload][:text_id] || ''}
    begin
      if params[:upload].present? && params[:upload][:img].present? && remotipart_submitted?
        upload_info = upload_picture params[:upload][:img]
        @result[:status] = true
        @result[:message] = "![#{upload_info[:file_name]}](/images/#{upload_info[:real_file_name]})"
      end
    rescue UploadException => e
      @result[:message] = e.message
    end
    respond_to do |format|
      format.js
    end
  end
def show
  @user=User.find params[:id]
  order = 'updated_at desc'
  @res0=@user.tasks
  @res1=Task.where('taker_id = ?',@user.id).where('status = ?',2)
  @res2=@user.comments
  @issue_tasks=@res0.order(order).page(params[:page]).per(Settings.itask.default_page_size)
  @finish_tasks=@res1.order(order).page(params[:page]).per(Settings.itask.default_page_size)
  @messages=@res2.order(order).page(params[:page]).per(Settings.itask.default_page_size)
  respond_to do |format|
    format.html
    format.js
  end
end

  protected

  def to_login(user)
    session[:user_id] = user.id
  end
  def upload_picture(file)
    upload_path = File.join Rails.root, 'public/images'
    upload = SimpleFileupload.new upload_path:upload_path, max_size: 1024*1024*2, type: 'image'
    upload_info = upload.upload file
  end
end
