# frozen_string_literal: true

class PagesController < ApplicationController
  helper ApplicationHelper
  skip_before_action :authenticate_user!, only: [:home, :pro, :corporate, :help]

  def home
    @user = current_user
  end

  def dashboard
    @user = current_user
  end

  def pro
    @user = current_user
  end

  def help; end
end
