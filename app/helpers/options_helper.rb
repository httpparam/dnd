module OptionsHelper
  def experience_levels
    ["0 sessions", "1-3 sessions", "4-20 sessions", ">20 sessions"]
  end

  def role_options
    ["Dungeon Master", "Player", "Supporter / Helper"]
  end

  def playstyle_options
    [
      { icon: "user", label: "Acting" },
      { icon: "zap", label: "Instigating" },
      { icon: "map", label: "Adventuring" },
      { icon: "target", label: "Optimizing" }
    ]
  end

  def atmosphere_options
    [
      { icon: "sparkles", label: "Classic High Fantasy" },
      { icon: "ghost", label: "Dark Horror" },
      { icon: "smile", label: "General Silliness" }
    ]
  end

  def availability_days
    %w[Mon Tue Wed Thu Fri Sat Sun]
  end

  def availability_times
    %w[Morning Afternoon Evening]
  end

  def campaign_statuses
    ["Accepting", "Forming"]
  end

  def campaign_atmospheres
    ["Classic High Fantasy", "Dark Horror", "General Silliness"]
  end

  def campaign_needs
    ["Tank", "Supporter", "Healer", "Optimizer", "DM"]
  end
end
