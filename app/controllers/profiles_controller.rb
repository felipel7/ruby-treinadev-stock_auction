class ProfilesController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!
  before_action -> { check_admin_role(current_user) }

  def index
    @users = User.all
  end

  def block
    return unless current_user.is_admin?
    @user = User.find(params[:id])
    @blocked_cpf = BlockedCpf.find_by(cpf: @user.cpf)

    if @blocked_cpf
      flash[:alert] = "CPF já está bloqueado."
    else
      @blocked_cpf = BlockedCpf.create!(cpf: @user.cpf)
      flash[:notice] = "CPF bloqueado com sucesso."
    end

    redirect_to profiles_path
  end

  def unblock
    return unless current_user.is_admin?

    @user = User.find(params[:id])
    @blocked_cpf = BlockedCpf.find_by(cpf: @user.cpf)

    @blocked_cpf.destroy

    flash[:notice] = "CPF foi desbloqueado com sucesso."
    redirect_to profiles_path
  end
end
