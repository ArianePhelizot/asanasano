# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class SlotsController < ApplicationController
  before_action :find_course, only: %i(new create edit update)
  before_action :find_slot,
                only: %i(edit update destroy desinscription
                         desinscription_from_course_page desinscription_from_dashboard
                         cancellation_with_refund?)

  def new
    # récupérer les infos de la dernière séance créée
    # créer la nouvelle slot avec ces attributs
    @slot = Slot.new
    @slot.course = @course
    authorize @slot
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def create
    @slot = Slot.new(slot_params)
    @slot.start_at = DateTime.new(@slot.date.cwyear, @slot.date.month,
                                  @slot.date.mday, @slot.start_at.hour,
                                  @slot.start_at.min)
    @slot.end_at = DateTime.new(@slot.date.cwyear, @slot.date.month,
                                 @slot.date.mday, @slot.end_at.hour,
                                 @slot.end_at.min)
    @slot.course = @course
    @group = @course.group
    authorize @slot # check authorization before save
    if @slot.save
      respond_to do |format|
        format.html do redirect_to course_path(@course) end
        format.js  # <-- will render `app/views/slots/create.js.erb`
      end
    else
      respond_to do |format|
        format.html do render "courses/show" end
        format.js  # <-- idem
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def edit
    authorize @slot # check authorization before edit
  end

  def update
    authorize @slot # check authorization before update
    if @slot.update(slot_params)
      redirect_to course_path(@course)
    else
      render :edit
    end
  end

  def destroy
    authorize @slot
    @course = @slot.course
    @slot.destroy
    redirect_to course_path(@course)
  end

  def desinscription_from_course_page
    desinscription

    @course = @slot.course

    respond_to do |format|
      format.html do redirect_to course_path(@course) end
      format.js # <-- will render `app/views/slots/desinscription.js.erb`
    end
  end

  def desinscription_from_dashboard
    desinscription

    redirect_to dashboard_path
  end

  private

  def slot_params
    params.require(:slot).permit(:participants_min,
                                 :date,
                                 :start_at,
                                 :end_at,
                                 :price)
  end

  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_slot
    @slot = Slot.find(params[:id])
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def desinscription
    authorize @slot
    @slot.users.delete(current_user)
    @order = Order.find_by user: current_user, slot: @slot
    # 2 cas de figure => faire une méthode pour savoir dans quel cas on est
    if cancellation_with_refund?
      # a/ nous sommes 24h avant le début du cours

      MangoPay::PayIn.refund(@order.mangopay_id, "Tag": current_user.account.tag,
                                                 "AuthorId": current_user.account.mangopay_id,
                                                 "DebitedFunds": { "Currency": "EUR",
                                                                   "Amount": @order.amount_cents },
                                                 "Fees": { "Currency": "EUR", "Amount": 0 })

      # Mark order as "refunded" in data base
      @order.state = "refunded"
      @order.settled = true
      @order.save

      # Alert message ad'hoc
      flash[:notice] = "Votre annulation pour la séance
      #{l(@order.slot.date, format: :long)} a bien été prise en compte.
      Le paiement par carte a été annulé. "

      # Mail ad'hoc
      OrderMailer.slot_cancellation_with_refund_confirmation(current_user, @order).deliver_now
    else
      # b/ nous sommes au delà de cette limite
      # Alert message ad'hoc
      flash[:notice] = "Votre annulation pour la séance
      #{l(@order.slot.date, format: :long)} a bien été prise en compte.
      Le paiement par carte a été annulé. "
      # Mail ad'hoc de confirmation
      OrderMailer.slot_cancellation_confirmation(current_user, @order).deliver_now
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def cancellation_with_refund?
    (DateTime.now.to_i - @slot.start_at.to_i) / 60 * 60 > 24
  end
end
# rubocop:enable Metrics/ClassLength
