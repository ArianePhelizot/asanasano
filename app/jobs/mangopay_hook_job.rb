class MangopayHookJob < ApplicationJob
  queue_as :default

  def perform
    # Petit audit des hooks créés
    # Liste des hooks existants
    mangopayhooks = MangoPay::Hook.fetch("page" => 1, "per_page" => 1)

    payin(mangopayhooks)
    refund(mangopayhooks)
    payout(mangopayhooks)
  end

  def payin(mangopayhooks)
    # Check si hook créé pour l'événement "PAYIN_NORMAL_SUCCEEDED"
    # Si le nb de hook pour "PAYIN_NORMAL_SUCCEEDED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYIN_NORMAL_SUCCEEDED") }.empty?
    # Alors il faut crée un hook
    MangoPay::Hook.create(
      "EventType": "PAYIN_NORMAL_SUCCEEDED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payment_succeeded/"
    )

    # Check si hook créé pour l'événement "PAYIN_NORMAL_FAILED"
    # Si le nb de hook pour "PAYIN_NORMAL_FAILED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYIN_NORMAL_FAILED") }.empty?
    MangoPay::Hook.create(
      "EventType": "PAYIN_NORMAL_FAILED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payment_failed/"
    )
  end

  def refund(mangopayhooks)
    # Check si hook créé pour l'événement "PAYIN_REFUND_SUCCEEDED"
    # Si le nb de hook pour "PAYIN_REFUND_SUCCEEDED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYIN_REFUND_SUCCEEDED") }.empty?
    # Alors il faut crée un hook
    MangoPay::Hook.create(
      "EventType": "PAYIN_REFUND_SUCCEEDED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payin_refund_succeeded/"
    )

    # Check si hook créé pour l'événement "PAYIN_REFUND_FAILED"
    # Si le nb de hook pour "PAYIN_REFUND_FAILED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYIN_REFUND_FAILED") }.empty?
    # Alors il faut crée un hook
    MangoPay::Hook.create(
      "EventType": "PAYIN_REFUND_FAILED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payin_refund_failed/"
    )
  end

  def payout(mangopayhooks)
    # Check si hook créé pour l'événement "PAYOUT_NORMAL_SUCCEEDED"
    # Si le nb de hook pour "PAYOUT_NORMAL_SUCCEEDED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYOUT_NORMAL_SUCCEEDED") }.empty?
    # Alors il faut crée un hook
    MangoPay::Hook.create(
      "EventType": "PAYOUT_NORMAL_SUCCEEDED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payout_normal_succeeded/"
    )

    # Check si hook créé pour l'événement "PAYOUT_NORMAL_FAILED"
    # Si le nb de hook pour "PAYOUT_NORMAL_FAILED" < 1
    next if mangopayhooks.select { |hash| hash.value?("PAYOUT_NORMAL_FAILED") }.empty?
    # Alors il faut crée un hook
    MangoPay::Hook.create(
      "EventType": "PAYOUT_NORMAL_FAILED",
      "Url": default_url_options_for_mangopay[:host] + "/hooks/payout_normal_failed/"
    )
  end
end
