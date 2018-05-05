Koudoku::SubscriptionsController.class_eval do
  prepend_before_action :authenticate_user_using_token!, only: [
    :index
  ]

  before_action :set_session_cookie_if_token_authenticated!, only: [
    :index
  ]

  def load_owner
    unless params[:owner_id].nil?
      if current_owner.present?

        # we need to try and look this owner up via the find method so that we're
        # taking advantage of any override of the find method that would be provided
        # by older versions of friendly_id. (support for newer versions default behavior
        # below.)

        id = params[:owner_id]
        if id == 'default'
          searched_owner = current_user.devices.first rescue nil
        else
          searched_owner = current_owner.class.find(params[:owner_id]) rescue nil
        end

        # if we couldn't find them that way, check whether there is a new version of
        # friendly_id in place that we can use to look them up by their slug.
        # in christoph's words, "why?!" in my words, "warum?!!!"
        # (we debugged this together on skype.)
        if searched_owner.nil? && current_owner.class.respond_to?(:friendly)
          searched_owner = current_owner.class.friendly.find(params[:owner_id]) rescue nil
        end

        if current_owner.try(:id) == searched_owner.try(:id)
          @owner = current_owner
        else
          return unauthorized
        end
      else
        return unauthorized
      end
    end
  end

  def authenticate_user_using_token!
    if request.headers["HTTP_X_USER_EMAIL"].present? &&
        request.headers["HTTP_X_USER_TOKEN"].present?

      u = User.find_by(email: request.headers["HTTP_X_USER_EMAIL"])

      if u.present?
        token_authenticated = Devise.secure_compare(
          u.authentication_token,
          request.headers["HTTP_X_USER_TOKEN"]
        )

        if token_authenticated
          @current_user = u
        end
      end
    end
  end

  def set_session_cookie_if_token_authenticated!
    if request.headers["HTTP_X_USER_EMAIL"].present? &&
        request.headers["HTTP_X_USER_TOKEN"].present? &&
        current_user.present?

      warden.set_user(current_user, scope: :user)
    end
  end

  if Cogli.force_tutorial?
    before_action :verify_tutorial, except: [:new, :create]
  end

  def verify_tutorial
    if action_name == 'show' ||
        action_name == 'edit' ||
        action_name == 'index'
      redirect_tutorial_for!("step_1")
    end
  end

  def show_existing_subscription
    if @owner.subscription.present?
      redirect_to edit_owner_subscription_path(@owner, @owner.subscription)
    end
  end

  def cancel
    flash[:notice] = "You've successfully cancelled your subscription."
    @subscription.canceling = true
    @subscription.canceled_at = Time.now
    @subscription.save
    redirect_to main_app.account_path
  end

  def update
    if @subscription.update_attributes(subscription_params)
      flash[:notice] = "You've successfully updated your subscription."
      redirect_to main_app.account_path
    else
      flash[:error] = 'There was a problem processing this transaction.'
      render :edit
    end
  end

  private

    def after_new_subscription_path
      if current_user.present? && current_user.tutorial_screen == "step_2" && current_user.tutorial_seen.blank?
        current_user.tutorial_screen = "step_1"
        tutorial_step = Tutorial.find_by_page_name "step_2"
        tutorial = UserTutorial.where(user_id: current_user.id, tutorial_id: tutorial_step.id).first
        tutorial.seen = true
        tutorial.save
        current_user.save
      end
      main_app.account_path
    end
end

