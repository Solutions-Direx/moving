class ActivityObserver < ActiveRecord::Observer
  # just observer report for now!
  # DO NOT observe quote!!!
  observe :report
  
  def after_create(trackable)
    if trackable.respond_to?(:quote)
      act = Activity.new
      act.actor_id = User.current_user.present? ? User.current_user.id : nil
      act.trackable = trackable
      act.action = 'create'
      act.quote_id = trackable.quote_id
      act.save
    else
      raise "Activity does not support #{trackable.class.to_s}."
    end
  end

  def after_update(trackable)
    if trackable.respond_to?(:quote)
      act = Activity.new
      act.actor_id = User.current_user.present? ? User.current_user.id : nil
      act.trackable = trackable
      act.action = 'update'
      act.quote_id = trackable.quote_id
      act.save
    else
      raise "Activity does not support #{trackable.class.to_s}."
    end
  end

  def after_destroy(trackable)
    Activity.destroy_all(trackable_id: trackable.id, trackable_type: trackable.class.to_s)
  end

end