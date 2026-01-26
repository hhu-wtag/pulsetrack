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
    }
  }.freeze

  def team_theme(is_active, *keys)
    state = is_active ? :active : :inactive

    TEAM_THEMES[state].slice(*keys).values.join(" ")
  end
end
