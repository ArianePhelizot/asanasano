# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class SlotsController < ApplicationController
  before_action :find_course, only: %i(new create edit update)
  before_action :find_slot,
                only: %i(edit update cancel desinscription
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

  def cancel
    authorize @slot
    @course = @slot.course

    if @slot.users.empty?
      @slot.destroy
    else
      @slot.status = "cancelled"
      @slot.save
      # rembourser les participants

      # identifier les orders correspondants
      order_to_refund = @slot.orders.select { |order|
        order.state == "paid" && order. settled == false
      }
      # faire un refund pour chaque order
      order_to_refund.each do |order|
        refund_order(order, "refund_for_slot_cancellation")
        # prévenir les participants après remboursement
        # avec un mail ad'hoc
      end
    end

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
                                 :price,
                                 :price_cents)
  end

  def find_course
    @course = Course.find(params[:course_id])
  end

  def find_slot
    @slot = Slot.find(params[:id])
  end

  def desinscription
    authorize @slot
    @slot.users.delete(current_user)
    @order = Order.find_by user: current_user, slot: @slot
    # 2 cas de figure => faire une méthode pour savoir dans quel cas on est
    if desinscription_with_refund?
      # a/ nous sommes à plus de 24h avant le début du cours
      refund_order(@order, "ask_for_refund")

    else
      # b/ nous sommes en deça de cette limite
      # Alert message ad'hoc
      @order.settled = true
      @order.save!
      flash[:notice] = "Votre annulation pour la séance
      #{l(@order.slot.date, format: :long)} a bien été prise en compte. "
      # Mail ad'hoc de confirmation
      OrderMailer.slot_cancellation_confirmation(@order).deliver_now
    end
  end

  def refund_order(order, order_state)
    log_error = nil

    begin
      mangopay_refund = MangoPay::PayIn.refund(order.mangopay_id,
                                              "Tag": order_state + order.mangopay_order_tag,
                                              "AuthorId": order.user.account.mangopay_id,
                                              "DebitedFunds": { "Currency": "EUR",
                                                                "Amount": order.amount_cents },
                                              "Fees": { "Currency": "EUR", "Amount": 0 })

      # Mark order as "refunded" in data base
      order.state = order_state
      order.refund_mangopay_id = mangopay_refund["Id"]
      order.save
    rescue MangoPay::ResponseError => ex
      log_error = ex.message
    rescue => ex
      log_error = ex.message
    ensure
      MangopayLog.create(event: "refund_creation",
                         mangopay_answer: mangopay_refund,
                         user_id: order.user.id.to_i,
                         error_logs: log_error)
    end

    if mangopay_refund["ResultMessage"] == "Success"
      flash[:notice] = "Votre annulation pour la séance
      #{l(@order.slot.date, format: :long)} a bien été prise en compte.
      Le paiement par carte correspondant vous sera remboursé. "
    else
      IssueMailer.payin_refund_failed(@order, mangopay_refund["ResultMessage"]).deliver_now
      flash[:alert] = "Damned! Nous avons bien pris en compte l'annulation de votre séance
      #{l(@order.slot.date, format: :long)},
      mais il y a visiblement eu un problème sur son remboursement.
      Nous allons étudier et régler le problème au plus vite. "
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def desinscription_with_refund?
    free_refund_policy = @slot.course.coach.params_set.free_refund_policy_in_hours
    (@slot.start_at.to_i - DateTime.now.to_i) / (60 * 60) > free_refund_policy
  end
end
# rubocop:enable Metrics/ClassLength
