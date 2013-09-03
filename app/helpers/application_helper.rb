module ApplicationHelper

	  def time_to_str time

    time.strftime("%Y-%m-%d") unless time.nil?

  end
  
end
