# frozen_string_literal: true

class PagesController < ApplicationController
  helper ApplicationHelper
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @user = current_user
  end

  def dashboard
    @user = current_user
  end
end
