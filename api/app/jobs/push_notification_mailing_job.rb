class PushNotificationMailingJob < ApplicationJob
  queue_as :default
  before_perform :init_redis


  def perform(content)
    p fcm_push_notification_to_all(content)
  end

  protected

  def fcm_push_notification_to_all(content)
    fcm_client = FCM.new(Rails.application.secrets.api_fcm_token) # set your FCM_SERVER_KEY
    body = content

    options = { priority: 'high',
                data: { message: body },
                notification: { body: body,
                                title: 'У вас новое сообщение от клуба!',
                                sound: 'default',
                                click_action: 'FLUTTER_NOTIFICATION_CLICK' } }
                                
    registration_ids = User.where.not(push_token: 0).pluck(:push_token)

    registration_ids.uniq.each_slice(999) do |registration_id|
      response = fcm_client.send(registration_id, options)
      response = JSON.parse(response[:body]).deep_transform_keys(&:to_sym)
      if response[:failure] > 0
        @invalid_pushes = []

        results_pushes = response[:results]

        results_pushes.each_index do |index_result_push|
          @invalid_pushes << registration_ids[index_result_push] if results_pushes[index_result_push].include?(:error)
        end

        @invalid_pushes.each do |invalid_push|
          User.where(push_token: invalid_push).update_all(push_token: 0)
        end
      end
      return { "push_notification": { "success": response[:success], "failure": response[:failure] } }
    end
  end
end
