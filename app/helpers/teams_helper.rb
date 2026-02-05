module TeamsHelper
  TEAM_THEMES = {
    active: {
      base: "emerald-500",
      bg: "bg-emerald-950/20",
      text: "text-emerald-700",
      border: "border-emerald-900/50",
      badge: "badge-success"
    },
    inactive: {
      base: "slate-400",
      bg: "bg-slate-900",
      text: "text-slate-400",
      border: "border-slate-800",
      badge: "badge-ghost"
    },
    role: {
      admin: { badge: "badge badge-outline badge-primary bg-primary/10 text-primary border-primary/20" },
      editor: { badge: "badge badge-outline badge-secondary bg-secondary/10 text-secondary border-secondary/20" },
      viewer: { badge: "badge badge-outline badge-info bg-base-300/50 text-base-content/60" }
    }
  }.freeze

  def role_theme(value)
    TEAM_THEMES[:role][value.to_sym][:badge]
  end

  def team_theme(is_active, *keys)
    state = is_active ? :active : :inactive

    TEAM_THEMES[state].slice(*keys).values.join(" ")
  end
end
